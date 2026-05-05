# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Breaking

- Requires Nextflow >=25.10
- Requires [uv](https://docs.astral.sh)
- Requires nf-core/tools >=v3.3.1

### Added

- Improved cookiecutter template harmonized with current utia-gc/ngs standard: Revision and setup options, .gitignore, Makefile
- `params.exploratoryTag` for tagging exploratory pipeline runs
- Option to hardlink files in setup
- `setup` profile
- Test class convenience wrapper for computing number succeeded tasks

### Removed

- Removed `campus`, `genomics`, and `utiacr` ISAAC config profiles
- Scripts for converting between old and current versions of nf-schema formats
- FastQC process level test

### Changed

- Began migration to workflow outputs
- Depends nf-schema v2.6.1
- Use standard assignment instead of set operator (utia-gc/ngs#155)
- Only refer to params in main workflow (utia-gc/ngs#156)
- Compute sequencing depth from FastQC results instead of greedily counting number of bases in reads (utia-gc/ngs#159)
- `workDir` in subdirectory determined by `params.projectTitle`
- Set resource requests using process `resourceLimits` instead of custom check resources method
- Write pipeline execution reports to hidden `.pipeline_execution_stats` directory
- Explicitly supply arguments to command line `Args` object as map

### Fixed

- FastQC SIGBUS error temp workaround (utia-gc/ngs#149)
