// Nextflow processes to interface with Airtable

process pull_experiment {

	tag "AT Experiment"
	executor 'local'

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

	input:
	path samplesheet

	script:
	"""
	update_sample_paths.py $samplesheet
	"""
}

process pull_samples {

	tag "AT Samples"

	input:
	val exp_id

	output:
	path ("samplesheet.csv")

	script:
	"""
	pull_samples.py  "RNA-Seq" $exp_id
	"""
}
