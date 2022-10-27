process star {

	cpus 8
	memory '60 GB'
	time '24h'
	tag "${meta.id}"
	publishDir "${params.outdir}/${meta.id}"
	publishDir "${params.outdir}/bam", mode: 'copy', pattern: '*.bam*'

	module 'star/2.7.7a'
	module 'samtools'

	input:
	tuple val(meta), path(fq1), path(fq2)
	path index
	val quantMode

	output:
	tuple val(meta), path("*Aligned.sortedByCoord.out.bam"), path("*Aligned.sortedByCoord.out.bam.bai"), emit: bam
	tuple val(meta), path("*toTranscriptome.out.bam"), optional: true, emit: bam_transcriptome
	path "*Log*", emit: logs

	when:
	!params.skip_align

	script:
	def reads = params.single ? "$fq1" : "$fq1 $fq2"

	"""
	STAR \\
		--runThreadN ${task.cpus} \\
		--readFilesCommand zcat \\
		--genomeDir ${index} \\
		--readFilesIn $reads \\
		--outSAMtype BAM SortedByCoordinate \\
		${quantMode} \\
		--outFileNamePrefix ${meta.id}_ \\
		--outSAMunmapped Within

	samtools index ${meta.id}_Aligned.sortedByCoord.out.bam ${meta.id}_Aligned.sortedByCoord.out.bam.bai
	"""
}
