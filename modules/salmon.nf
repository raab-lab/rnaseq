// Salmon quant

process salmon {

	cpus 8
	module 'salmon/1.8.0'
	memory { 32.GB * task.attempt }
	time { 24.h * task.attempt }
	
	tag "${meta.id}"
	publishDir "${params.outdir}/quants/", mode: 'copy'
	publishDir "${params.outdir}/${meta.id}"

	input:
	tuple val(meta), path(fq1), path(fq2)
	path index 
	val options

	output:
	path "${meta.id}", emit: quants
	path "*", emit: logs

	when:
	!params.skip_quant

	"""
	salmon quant \\
			-i ${index} \\
			-l A \\
			${options} \\
			-1 "$fq1" \\
			-2 "$fq2" \\
			-p ${task.cpus} \\
			-o ${meta.id}
	"""
}

process salmon_single {

	cpus 8
	memory { 32.GB * task.attempt }
	time { 24.h * task.attempt }

	tag "${meta.id}"
	publishDir "${params.outdir}/${meta.id}"

	input:
	tuple val(meta), path(fq1)
	path index
	val options

	output:
	path "${meta.id}", emit: quants
	path "*", emit: logs

	"""
	module add salmon/1.5.2
	salmon quant \\
			-i ${index} \\
			-l A \\
			${options} \\
			-r "$fq1" \\
			-p 8 \\
			-o ${meta.id}
	"""
}

process star_salmon {

	cpus 8
	memory { 32.GB * task.attempt }
	time { 24.h * task.attempt }
	tag "${meta.id}"
	publishDir "${params.outdir}/salmonA/${meta.id}"

	input:
	tuple val(meta), path(bam)
	path transcripts
	val options
	val workflow

	output:
	path "${meta.id}", emit: quants
	path "*", emit: logs

	"""
	module add salmon/1.5.2
	salmon quant \\
			-t $transcripts \\
			-l A \\
			${options} \\
			-a $bam \\
			-p 8 \\
			-o ${meta.id}	
	"""
}
