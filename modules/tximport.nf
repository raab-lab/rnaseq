// Tximport

process tximport {

	cpus 2
	memory { 32.GB * task.attempt }
	publishDir "${params.outdir}", mode: 'copy'

	input:
	path tx2gene
	path quant
	val name
	val featInfo
	val method

	output:
	path "*.rds"

	"""
	module add r/4.0.3
	
	tximport.R $tx2gene $name $workflow $featInfo $method $quant
	"""
	
	
} 
