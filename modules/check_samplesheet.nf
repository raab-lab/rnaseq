process check_ss{
	module 'r/4.1.0'
	label 'single'
	tag "Samplesheet"

	input:
	path SS

	output:
	path 'samplesheet_*.csv'

	script:
	"""
	check_samplesheet.R $SS
	"""
}
