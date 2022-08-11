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
params.pull_experiment		= ''
params.pull_samples		= ''

// import subworkflows

include { CREATE_SAMPLESHEET }				from './subworkflows/create_samplesheet'
include { CREATE_SAMPLESHEET as AT_CREATE_SS}		from './subworkflows/create_samplesheet'

// import modules

include { pull_experiment; pull_samples }		from './modules/airtable'
include { update_paths }				from './modules/airtable'
include { create_ss }					from './modules/create_samplesheet'
include { check_ss }					from './modules/check_samplesheet'
include { fastqc }					from './modules/fastqc'
include { salmon }					from './modules/salmon'
include { star }					from './modules/star'
include { picard_cmm; picard_crsm }			from './modules/picard'
include { coverage as cov_fw }				from './modules/coverage'
include { coverage as cov_rev }				from './modules/coverage'
include { multiqc }					from './modules/multiqc'

// Pull reads from sample sheet and set channel

def parse_samplesheet(LinkedHashMap row){
	def meta = [:]
	meta.id		= row.ID
	meta.lib_id	= row.SampleID
	meta.cell_line	= row["Cell Line"]
	meta.trt	= row.Treatment
	meta.rep	= row.Replicate

	def array = [meta, file(row.R1), file(row.R2) ]

	return array
}

workflow RNASEQ {

	main:

	// Check samplesheet columns and create unique ID
	check_ss(params.sample_sheet)
	check_ss.out
		.splitCsv(header:true)
		.map { parse_samplesheet(it) }
		.set { READS }

	// FastQC
	fastqc(READS)

	// Quantify Expression 
	salmon(READS, params.salmon_idx, params.salmon_opts)

	// Align reads
	star(READS, params.star_idx, params.star_quantMode)

	// Picard QC
	picard_cmm(star.out.bam, params.genome)
	picard_crsm(star.out.bam, params.genome, params.ref_flat, params.ribo_intervals)

	// Coverage Tracks
	cov_fw(star.out.bam, 'forward')
	cov_rev(star.out.bam, 'reverse')

	// Collect all QC outputs to multiqc
	multiqc(
		fastqc.out.collect(),
		picard_cmm.out.mix(picard_crsm.out).collect(),
		salmon.out.logs.collect(),
		star.out.logs.collect()
	)

	
}

workflow {
	if (params.pull_experiment) {
	// TODO: Get experiment IDs into the samplesheet
		pull_experiment(params.pull_experiment) | AT_CREATE_SS | update_paths
		
	}
	if (params.create_samplesheet && params.sample_sheet) {
		exit 1, "ERROR: Conflicting samplesheet arguments. Choose one or the other."
	}

	if (params.create_samplesheet) {
		CREATE_SAMPLESHEET(params.create_samplesheet)
	}

	if (params.sample_sheet) {
		RNASEQ()
	}
}
