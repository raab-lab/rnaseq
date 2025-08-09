process fastqc {

	cpus 2
	memory { 8.GB * task.attempt }
	time { 8.h * task.attempt }
	module 'fastqc/0.12.1'

	tag "${meta.id}"
	publishDir "${params.outdir}/${meta.id}/qc"

	input:
	tuple val(meta), path(fq1), path(fq2)

	output:
	path "*.{zip,html}"

	when:
	!params.skip_qc

	script:
	def reads = params.single ? "$fq1" : "$fq1 $fq2"

	"""
	fastqc -t ${task.cpus} $reads
	"""
}

process trim {
	tag "${meta.id}"
	cpus 4
	memory { 8.GB * task.attempt }
	time { 8.h * task.attempt }
	module 'trim_galore/0.6.7'
	module 'fastqc'

	publishDir "${params.outdir}/${meta.id}/qc"

	input:
	tuple val(meta), path(fq1), path(fq2)

	output:
	tuple val(meta), path("*_val_1.fq.gz"), path("*_val_2.fq.gz"), emit: trimmed
	path "*.{zip,html}", emit: fqc

	when:
	!params.skip_qc

	script:
	def quality_flag = params.trim ? "-q ${params.quality_trim}" : ""
	def reads = params.single ? "$fq1" : "$fq1 $fq2"
	"""
	trim_galore -j ${task.cpus} --fastqc --paired --gzip --basename ${meta.id} ${quality_flag} ${reads}
	"""
}
