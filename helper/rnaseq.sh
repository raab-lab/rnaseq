#!/bin/bash

#SBATCH -c 2

#SBATCH --mem=10G

#SBATCH -t 24:00:00

#SBATCH -J NF

module add nextflow

## MODIFY THE SAMPLE SHEET AND EMAIL FOR YOUR RUN
nextflow run raab-lab/rnaseq \
		--sample_sheet /path/to/sample_sheet \
		-profile mm10/hg38 \
		--outdir /path/to/Output \
		-w /path/to/work \
		-with-report \
		-N <user@email.edu> \
		-latest \
		-ansi-log false \
		-resume


