#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
 * DSL2 Implementation of Raab Lab RNAseq pipeline
 *
 * Authors:	Peyton Kuhlers <peyton_kuhlers@med.unc.edu>
 * 		Jesse Raab <jesse_raab@med.unc.edu>
 *
 */

// Define pipeline-wide params
params.sample_sheet		= ''
params.outdir			= 'Output'
params.create_samplesheet 	= ''
params.new_experiment		= ''
params.pull_samples		= ''

// import subworkflows

include { CREATE_SAMPLESHEET }				from './subworkflows/create_samplesheet'
include { CREATE_SAMPLESHEET as AT_CREATE_SS}		from './subworkflows/create_samplesheet'
include { RNASEQ }					from './subworkflows/rnaseq'
include { RNASEQ as AT_RNASEQ }				from './subworkflows/rnaseq'

// import modules

include { pull_experiment; pull_samples }		from './modules/airtable'
include { update_paths }				from './modules/airtable'
include { helpMessage }					from './modules/functions'

// Pull reads from sample sheet and set channel

workflow {

	if (params.help) {
		log.info helpMessage()
	}

	if (params.new_experiment) {
	// TODO: Get experiment IDs into the samplesheet
		pull_experiment(params.new_experiment) | AT_CREATE_SS | update_paths
	}

	if (params.pull_samples) {
		pull_samples(params.pull_samples) | AT_RNASEQ
	}

	if (params.create_samplesheet && params.sample_sheet) {
		exit 1, "ERROR: Conflicting samplesheet arguments. Choose one or the other."
	}

	if (params.create_samplesheet) {
		CREATE_SAMPLESHEET(params.create_samplesheet)
	}

	if (params.sample_sheet) {
		RNASEQ(params.sample_sheet)
	}
}
