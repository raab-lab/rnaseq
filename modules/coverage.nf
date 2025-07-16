// Coverage Tracks
process coverage {

	tag "${meta.id}"
	module 'deeptools/3.5.4'
	cpus "${params.coverage_cores}"
	time '48h'
	memory '32G'
	publishDir "${params.outdir}/${meta.id}"
	publishDir "${params.outdir}/bw", mode: 'copy'

	input:
	tuple val(meta), path(bam), path(bai)
	val inclusion_regions
	val exclude_file
	val strand

	output:
	tuple val(meta), path("*.bw")

	when:
	!params.skip_align && !params.skip_coverage

	script:

	def exclude = exclude_file ? "--blackListFileName ${exclude_file}" : ""
	def region = inclusion_regions ? "--region ${inclusion_regions}" : ""

	"""
	bamCoverage -v -b ${bam} \\
		-o ${meta.id}_${strand}.bw \\
		--normalizeUsing RPKM \\
		--filterRNAstrand ${strand} \\
		${region} \\
		${exclude} \\
		--numberOfProcessors ${task.cpus}
	"""
}

process downsample_bam {

	tag "${meta.id}"
	module 'samtools'
	cpus 4
	time '4h'
	memory '8G'

	input:
	tuple val(meta), path(bam), path(bai)
	val downsample_pct

	output:
	tuple val(meta), path('*downsample.bam'), path('*downsample.bam.bai'), emit: bam

	script:

	"""
	samtools view -bh -s $downsample_pct -o ${meta.id}_downsample.bam $bam
	samtools index ${meta.id}_downsample.bam ${meta.id}_downsample.bam.bai
	"""
}
