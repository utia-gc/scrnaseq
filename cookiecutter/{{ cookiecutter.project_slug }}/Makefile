# Project setup
## Setup pipeline files
nf_setup_config := config/nextflow/setup.config
nf_setup_params := config/nextflow/params_setup.yaml
nf_setup_script := src/sbatch/nf_run_setup.sh
## Setup input file(s)
sample_decode := config/samplesheets/sample-name-decode.csv
## Setup output samplesheet
samplesheet := config/samplesheets/samplesheet.csv
# Process data
## Data processing pipeline files
nf_scrnaseq_config := config/nextflow/scrnaseq.config
nf_scrnaseq_params := config/nextflow/params_scrnaseq.yaml
nf_scrnaseq_script := src/sbatch/nf_run_scrnaseq.sh


.PHONY: all
all: setup process

.PHONY: setup
setup: $(samplesheet)
	@echo "Ran project setup"

$(samplesheet): .cache/nf_logs/setup.log
	@touch $(samplesheet)

.cache/nf_logs/setup.log: $(sample_decode) $(nf_setup_config) $(nf_setup_params) $(nf_setup_script)
	@echo "Run project setup pipeline"
	@sbatch --wait --verbose $(nf_setup_script)

.PHONY: process
process: .cache/nf_logs/scrnaseq.log
	@echo "Ran data processing"

.cache/nf_logs/scrnaseq.log: $(samplesheet) $(nf_scrnaseq_config) $(nf_scrnaseq_params) $(nf_scrnaseq_script)
	@echo "Run data processing pipeline"
	@sbatch --wait --verbose $(nf_scrnaseq_script)
