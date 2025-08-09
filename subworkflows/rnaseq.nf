// RNAseq workflow

// import modules

include { create_ss }					from '../modules/create_samplesheet'
include { check_ss }					from '../modules/check_samplesheet'
include { fastqc }					from '../modules/fastqc'
include { trim }					from '../modules/fastqc'
include { salmon }					from '../modules/salmon'
include { star }					from '../modules/star'
include { picard_cmm; picard_crsm }			from '../modules/picard'
include { coverage as cov_fw }				from '../modules/coverage'
include { coverage as cov_rev }				from '../modules/coverage'
include { downsample_bam }				from '../modules/coverage'
include { multiqc }					from '../modules/multiqc'

// Define workflow

def parse_samplesheet(LinkedHashMap row){
	def meta = [:]
	meta.sampleNum	= row.SampleNumber
	meta.id		= row.ID
	meta.lib_id	= row.SampleID
	meta.cell_line	= row["Cell Line"]
	meta.geno	= row.Genotype
	meta.trt	= row.Treatment
	meta.rep	= row.Replicate

	def array = params.single ? [meta, file(row.R1), []] : [meta, file(row.R1), file(row.R2)]

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
	if(params.trim || params.quality_trim) {
		trim(READS)
		READS=trim.out.trimmed
		QC=trim.out.fqc
	} else {
		fastqc(READS)
		QC=fastqc.out
	}

	// Quantify Expression 
	salmon(READS, params.salmon_idx, params.salmon_opts)

	// Align reads
	star(READS, params.star_idx, params.star_quantMode)

	// Picard QC
	picard_cmm(star.out.bam, params.genome)
	picard_crsm(star.out.bam, params.genome, params.ref_flat, params.ribo_intervals)

	// Coverage Tracks
	if(params.downsample) {
		downsample_bam(star.out.bam, params.downsample)
		BAM=downsample_bam.out.bam
	} else {
		BAM=star.out.bam
	}

	cov_fw(BAM, params.coverage_region, params.coverage_exclude, 'forward')
	cov_rev(BAM, params.coverage_region, params.coverage_exclude, 'reverse')

	// Collect all QC outputs to multiqc
	multiqc(
		QC.collect().ifEmpty([]),
		picard_cmm.out.mix(picard_crsm.out).collect().ifEmpty([]),
		salmon.out.logs.collect().ifEmpty([]),
		star.out.logs.collect().ifEmpty([])
	)

	
}
