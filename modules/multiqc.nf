process multiqc {

	cpus 2
	memory '16G'
	time { 8.h * task.attempt  }
	publishDir "${params.outdir}", mode: 'copy'

	module 'multiqc/1.11'

	input:
	path fastqc 
	path metrics
	path slm_log
	path star_log

	output:
	file "multiqc_report.html"
	file "multiqc_data"

	when:
	!params.skip_multiqc

	"""
	multiqc .
	"""
}
