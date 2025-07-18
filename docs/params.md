Parameters
==========

Defaults can be found either in nextflow.config or main.nf.

`--sample_sheet`

Path to the experiment samplesheet in csv format. It should be formatted as follows:

|Column	        |Description					|
|---------------|-----------------------------------------------|
|R1		|Full path to the first read 			|
|R2		|Full path to the second read 			|
|SampleNumber	|Immutable SampleNumber (Airtable)		|
|SampleID	|Unique sequencing library ID		   	|
|Cell Line	|Cell line identifier (i.e. HepG2)		|
|Genotype	|Genotype information (i.e. R1064K)		|
|Treatment	|Treatment or experimental conditions		|
|Replicate	|Experimental replicate number			|

Example:

    R1,R2,SampleNumber,SampleID,Cell Line,Treatment,Replicate
    /path/to/R1,/path/to/R2,626,UniqID,HepG2,Sorafenib,1

`--help`

Display this message

`--create_samplesheet </path/>`

Path to a directory of fastq.gz files

`--sample_sheet </path/>`

Path to CSV with fastq paths and sample metadata

`--new_experiment <ID>`

Experiment ID for new experiment to add to airtable

`--pull_samples <ID>`

Experiment ID to pull from airtable to run through pipeline

`-w </path/>`

Path to your desired work directory for intermediate output [Default: work]

`--outdir </path/>`

Path to your desired output directory [Default: Output]

`--star_idx </path/>`

Path to STAR index [Default:/proj/seq/data/STAR_genomes_v277/GRCh38_p13_GENCODE_primary]

`--star_quantMode` <value>

Use this flag to add arguments to the `--quantMode` option to STAR (see STAR manual for options)
Must have the form '--quantMode GeneCounts' when used on the command line [Default: None]

`--salmon_idx </path/>`

Path to salmon index [Default:/proj/seq/data/salmon_RNAseq_genomes/hg38_decoy/salmon_sa_index/default]

`--salmon_opts` <value>

Use this flag to change salmon options.
Must have form '--gcBias' when used on the command line [Default:'--gcBias --seqBias --posBias']

`--genome </path/>`

Path to genome fasta for picard [Default:/proj/seq/data/STAR_genomes_v277/GRCh38_p13_GENCODE_primary/GRCh38.primary_assembly.genome.fa]

`--ref_flat </path/>`

Path to refFlat file for picard [Default:/proj/seq/data/hg38_UCSC/Annotation/Genes.gencode/refFlat.txt.gz]

`--ribo_intervals </path/>`

Path to ribosomal intervals file for picard [Default:/proj/jraablab/users/pkuhlers/seq_resources/GRCh38_rRNA.interval_list]

`--single`

Flag to run the pipeline with single end reads

`--coverage_region`

Maps to deepTools `--region`

`--coverage_exclude`

Path to bed file for regions to exclude for coverage. Maps to deepTools `--blackListFileName`

`--coverage_cores`

Number of cores for computing coverage [Default: 6]

`--trim`

Flag to perform trimming prior to mapping [Default: False]

`--downsample <percent>`

Downsample to <percent> (ex. 0.1 to downsample to 10%) prior to coverage calculation [Default: OFF]

`--skip_coverage`

Flag to skip deepTools coverage

`--skip_align`

Flag to skip STAR alignment

`--skip_quant`

Flag to skip Salmon quantification

`--skip_qc`

Flag to skip FastQC and Picard

`--skip_multiqc`

`-profile`

Sets species specific variables. Either 'hg38' or 'mm10'.
The default pipeline parameters correspond to `-profile hg38`

Flag to skip multiqc report generation

`-latest`

Flag to pull the latest pipeline release from GitHub

`-with-report`

Flag to output a run report

`-N <user@email.edu>`

Email address to notify when the pipeline has finished

`-resume`

Flag to pick back up from last pipeline execution (works even if first time)
