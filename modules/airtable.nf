// Nextflow processes to interface with Airtable

process pull_experiment {

	tag "AT Experiment"
	executor 'local'
	module 'python/3.8.8'

	input:
	val exp_id

	output:
	stdout

	script:
	"""
	pull_experiment.py "RNA-Seq" $exp_id	
	"""
}

process update_paths {

	tag "Update"
	executor 'local'
	module 'python/3.8.8'

	input:
	path samplesheet

	script:
	"""
	update_samples.py $samplesheet
	"""
}

process pull_samples {

	tag "AT Samples"
	module 'python/3.8.8'

	input:
	val exp_id

	output:
	path ("samplesheet.csv")

	script:
	"""
	pull_samples.py  "RNA-Seq" $exp_id
	"""
}
