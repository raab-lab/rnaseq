raab-lab/rnaseq: Changelog
==============================

The format of this changelog is based on the [nf-core](https://github.com/nf-core/rnaseq/blob/master/CHANGELOG.md) changelog.


## [2.1] - 2024-11-21

This release adds new functionality for better processing of recent tt-seq samples.

### Updates

- Added an adapter trimming module
- Added option to downsample reads prior to running coverage
- Added option to increase cores for coverage
- Added option to subset to specific chromosome region or to use a bed file of regions to exclude
- STAR gene counts are output to 'outdir/star_counts' if requested
- Fixed logic that caused some steps to be run even with --skip_xxx 

### Parameters

| Old parameters         | New parameters         |
| ---------------------- | ---------------------- |
|                        | `--trim`	          |
|                        | `--downsample <pct>`   |
|                        | `--coverage_cores`     |
|                        | `--coverage_region`    |
|                        | `--coverage_exclude`   |

## [2.0] - 2023-10-10

:exclamation: Major Release

This release bumps several tool versions and introduces some changes.

### Updates

- The samplesheet now includes a new column called SampleNumber (see [docs](docs/params.md) for example)
- Bumped to pyairtable to version 2.1.0.post1 and refactored airtable scripts to accomodate
- Airtable is deprecating API keys, so code was refactored to take personal access tokens
- Bumped the nextflow version to the latest on longleaf

## [1.4] - 2023-08-09

### Updates

This small release adds an option to use the `-profiles` parameter. Profiles allow you to set a group of variables all at once.
The implemented profiles specifically simplify changing species specific parameters (mm10 vs hg38). See docs for usage.

### Parameters

| Old parameters         | New parameters         |
| ---------------------- | ---------------------- |
|                        | `-profile`	          |

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
