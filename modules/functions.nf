def helpMessage() { 
"""\
	==========================================================================================
	______            _       _           _      ______ _   _   ___         _____            
	| ___ \\          | |     | |         | |     | ___ \\ \\ | | / _ \\       /  ___|           
	| |_/ /__ _  __ _| |__   | |     __ _| |__   | |_/ /  \\| |/ /_\\ \\______\\ `--.  ___  __ _ 
	|    // _` |/ _` | '_ \\  | |    / _` | '_ \\  |    /| . ` ||  _  |______|`--. \\/ _ \\/ _` |
	| |\\ \\ (_| | (_| | |_) | | |___| (_| | |_) | | |\\ \\| |\\  || | | |      /\\__/ /  __/ (_| |
	\\_| \\_\\__,_|\\__,_|_.__/  \\_____/\\__,_|_.__/  \\_| \\_\\_| \\_/\\_| |_/      \\____/ \\___|\\__, |
											      | |
											      |_|
	===========================================================================================
	Usage:
	nextflow run raab-lab/rnaseq (--create_samplesheet|--sample_sheet) </path/>
	nextflow run raab-lab/rnaseq (--new_experiment|--pull_samples) <ID>

	Arguments:
	--help
		Display this message

	--create_samplesheet </path/>
		Path to a directory of fastq.gz files

	--sample_sheet </path/>
		Path to CSV with fastq paths and sample metadata

	--new_experiment <ID>
		Experiment ID for new experiment to add to airtable

	--pull_samples <ID>
		Experiment ID to pull from airtable to run through pipeline

	-w </path/>
		Path to your desired work directory for intermediate output [Default: work]

	--outdir </path/>
		Path to your desired output directory [Default: Output]

	Tool Options:
	--star_idx </path/>
		Path to STAR index [Default:/proj/seq/data/STAR_genomes_v277/GRCh38_p13_GENCODE_primary]

	--salmon_idx </path/>
		Path to salmon index [Default:/proj/seq/data/salmon_RNAseq_genomes/hg38_decoy/salmon_sa_index/default]

	--genome </path/>
		Path to genome fasta for picard [Default:/proj/seq/data/STAR_genomes_v277/GRCh38_p13_GENCODE_primary/GRCh38.primary_assembly.genome.fa]

	--ref_flat </path/>
		Path to refFlat file for picard [Default:/proj/seq/data/hg38_UCSC/Annotation/Genes.gencode/refFlat.txt.gz]

	--ribo_intervals </path/>
		Path to ribosomal intervals file for picard [Default:/proj/jraablab/users/pkuhlers/seq_resources/GRCh38_rRNA.interval_list]

	Arguments to Always Include:
	-latest
		Flag to pull the latest pipeline release from GitHub

	-with-report
		Flag to output a run report

	-N <user@email.edu>
		Email address to notify when the pipeline has finished

	-resume
		Flag to pick back up from last pipeline execution (works even if first time)

""".stripIndent()

}
