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

// import RNAseq modules

include { create_ss }			from './modules/create_samplesheet'
include { check_ss }			from './modules/check_samplesheet'
include { fastqc }			from './modules/fastqc'
include { salmon }			from './modules/salmon'
include { star }			from './modules/star'
include { coverage as cov_fw }		from './modules/coverage'
include { coverage as cov_rev }		from './modules/coverage'
include { multiqc }			from './modules/multiqc'

// Pull reads from sample sheet and set channel

def parse_samplesheet(LinkedHashMap row){
	def meta = [:]
	meta.id		= row.ID
	meta.lib_id	= row.lib_id
	meta.cell_line	= row.cell_line
	meta.trt	= row.treatment
	meta.rep	= row.replicate

	def array = [meta, file(row.read1), file(row.read2) ]

	return array
}

workflow CREATE_SAMPLESHEET {

	take:
	inventory

	main:

	create_ss(inventory)

	emit:
	create_ss.out

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

	// Coverage Tracks
	cov_fw(star.out.bam, 'forward')
	cov_rev(star.out.bam, 'reverse')

	// Collect all QC outputs to multiqc
	multiqc(
		fastqc.out.collect(),
		salmon.out.logs.collect(),
		star.out.logs.collect()
	)

	
}

workflow {
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
