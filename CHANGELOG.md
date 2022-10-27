raab-lab/rnaseq: Changelog
==============================

The format of this changelog is based on the [nf-core](https://github.com/nf-core/rnaseq/blob/master/CHANGELOG.md) changelog.

## [1.3] - 2022-10-27

This release adds handling for single end reads. Simply leave the R2 column of the sample sheet blank and add --single to the command line.

### Parameters

| Old parameters         | New parameters         |
| ---------------------- | ---------------------- |
|                        | `--single`		  |

## [1.2] - 2022-09-06

### Updates

This release adds options to skip specific modules of the pipeline. This way if i.e. only counts are needed everything else can be skipped.

### Parameters

| Old parameters         | New parameters         |
| ---------------------- | ---------------------- |
|                        | `--skip_quant`	  |
|                        | `--skip_align`	  |
|                        | `--skip_coverage`  	  |
|                        | `--skip_qc`	  	  |
|                        | `--skip_multiqc`  	  |

## [1.1] - 2022-08-30

:exclamation: Big Enhancement

This release integrates Airtable into the pipeline. This should facilitate easier sample sheet creation and provide a single location for all sequencing data to be stored. Additionally, a help parameter to display documentation (along with big doc updates).

### Parameters

| Old parameters         | New parameters         |
| ---------------------- | ---------------------- |
|                        | `--new_experiment`     |
|                        | `--pull_samples`	  |
|                        | `--help`	  	  |

## [1.0.0] - 2022-07-28

### Updates

- This is the first release of the RNAseq pipeline. During testing everything seems to be running okay aside from a two samples in my test run that keep timing out when computing coverage tracks. This issue will hopefully be resolved in the next release.

### Parameters

Parameters for the first release can be found [here](docs/params.md).
