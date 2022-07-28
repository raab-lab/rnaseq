// Coverage Tracks
process coverage {

	tag "${meta.id}"
	module 'deeptools/3.2.0'
	cpus 6
	memory '24G'	
//	label 'medium'
	publishDir "${params.outdir}/${meta.id}"
	publishDir "${params.outdir}/bw", mode: 'copy'

	input:
	tuple val(meta), path(bam), path(bai)
	val strand

	output:
	tuple val(meta), path("*.bw")

	script:
	"""
	bamCoverage -b ${bam} \\
		-o ${meta.id}_${strand}.bw \\
		--normalizeUsing RPKM \\
		--filterRNAstrand ${strand} \\
		--numberOfProcessors ${task.cpus}
	"""

}
