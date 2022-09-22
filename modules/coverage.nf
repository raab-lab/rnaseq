// Coverage Tracks
process coverage {

	tag "${meta.id}"
	module 'deeptools/3.2.0'
	cpus 6
	time '24h'
	memory '32G'
//	label 'medium'
	publishDir "${params.outdir}/${meta.id}"
	publishDir "${params.outdir}/bw", mode: 'copy'

	input:
	tuple val(meta), path(bam), path(bai)
	val strand

	output:
	tuple val(meta), path("*.bw")

	when:
	!params.skip_align || !params.skip_coverage

	script:
	"""
	bamCoverage -b ${bam} \\
		-o ${meta.id}_${strand}.bw \\
		--normalizeUsing RPKM \\
		--filterRNAstrand ${strand} \\
		--numberOfProcessors ${task.cpus}
	"""

}
