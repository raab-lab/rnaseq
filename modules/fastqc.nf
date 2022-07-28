process fastqc {

	cpus 2
	memory { 8.GB * task.attempt }
	time { 8.h * task.attempt }
	module 'fastqc/0.11.8'

	tag "${meta.id}"
	publishDir "${params.outdir}/${meta.id}/qc"

	input:
	tuple val(meta), path(fq1), path(fq2)

	output:
	path "*.{zip,html}"

	script:
	"""
	fastqc -t ${task.cpus} "$fq1" "$fq2"
	"""
}
