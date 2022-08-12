// RNAseq workflow

// import modules

include { create_ss }					from '../modules/create_samplesheet'
include { check_ss }					from '../modules/check_samplesheet'
include { fastqc }					from '../modules/fastqc'
include { salmon }					from '../modules/salmon'
include { star }					from '../modules/star'
include { picard_cmm; picard_crsm }			from '../modules/picard'
include { coverage as cov_fw }				from '../modules/coverage'
include { coverage as cov_rev }				from '../modules/coverage'
include { multiqc }					from '../modules/multiqc'

// Define workflow

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

	take:
	samplesheet

	main:

	// Check samplesheet columns and create unique ID
	check_ss(samplesheet)
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
