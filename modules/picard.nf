// Picard QC tools

process picard_cmm {

	cpus 1
	memory '20G'
	time '8h'
	tag "${sample}"
	publishDir "${params.outdir}/${sample}/qc"

	input:
	tuple val(sample), file(bam), file(bai)
	path genome

	output:
	path "*metrics*"

	"""
	module add picard/2.23.4
	module add r
	picard CollectMultipleMetrics \
		I=$bam \
		O=${sample} \
		R=${genome}
	"""
}



process picard_crsm {

	cpus 1
	memory '20G'
	time '8h'
	tag "${sample}"
	publishDir "${params.outdir}/${sample}/qc"

	input:
	tuple val(sample), file(bam), file(bai)
	path genome
	path ref_flat
	path ribo_intervals

	output:
	path "*metrics*"

	"""
	module add picard/2.23.4
	module add r
	picard CollectRnaSeqMetrics \
		I=$bam \
		O=${sample}_rnaseq_metrics \
		R=${genome} \
		REF_FLAT=${ref_flat} \
		STRAND_SPECIFICITY=SECOND_READ_TRANSCRIPTION_STRAND \
		RIBOSOMAL_INTERVALS=${ribo_intervals}
	"""
}

process picard_md {

	cpus 1
	memory '50G'
	time '12h'
	tag "${sample}"
	publishDir "${params.outdir}/${sample}/qc"

	input:
	tuple val(sample), file(bam), file(bai)

	output:
	path "*metrics*"

	"""
	module add picard/2.23.4
	module add r
	picard MarkDuplicates \
		I=$bam \
		O=/dev/null \
		M=${sample}_dup_metrics.txt
	"""
}
