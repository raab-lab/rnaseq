#!/bin/bash

module add nextflow
source ~/.secrets/airtable

## MODIFY THE EXPERIMENT ID FOR THE EXPERIMENT YOU WANT TO RUN
nextflow run raab-lab/rnaseq \
	--new_experiment $1 \
	-r dev \
	-latest

