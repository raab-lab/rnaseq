// Picard QC tools

process picard_cmm {

	cpus 1
	memory '20G'
	time '8h'
	tag "${meta.id}"

	module 'r/3.6.0'
	module 'picard/2.23.4'
	publishDir "${params.outdir}/${meta.id}/qc"

	input:
	tuple val(meta), path(bam), path(bai)
	path genome

	output:
	path "*metrics*"

	"""
	picard CollectMultipleMetrics \
		I=$bam \
		O=${meta.id} \
		R=${genome}
	"""
}



process picard_crsm {

	cpus 1
	memory '20G'
	time '8h'
	tag "${meta.id}"
	module 'r/3.6.0'
	module 'picard/2.23.4'
	publishDir "${params.outdir}/${meta.id}/qc"

	input:
	tuple val(meta), path(bam), path(bai)
	path genome
	path ref_flat
	path ribo_intervals

	output:
	path "*metrics*"

	"""
	picard CollectRnaSeqMetrics \
		I=$bam \
		O=${meta.id}_rnaseq_metrics \
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
	tag "${meta.id}"
	publishDir "${params.outdir}/${meta.id}/qc"

	input:
	tuple val(meta), file(bam), file(bai)

	output:
	path "*metrics*"

	"""
	module add picard/2.23.4
	module add r
	picard MarkDuplicates \
		I=$bam \
		O=/dev/null \
		M=${meta.id}_dup_metrics.txt
	"""
}
