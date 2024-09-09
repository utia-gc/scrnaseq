#!/bin/bash
#SBATCH --job-name={{ cookiecutter.project_slug }}_scrnaseq
#SBATCH --cpus-per-task=1
#SBATCH --mem=3GB
#SBATCH --time=03-00:00:00
#SBATCH --error=.cache/sbatch_logs/%j_-_%x.err
#SBATCH --output=.cache/sbatch_logs/%j_-_%x.out
#SBATCH --account={{ cookiecutter.slurm_account }}
#SBATCH --partition={{ cookiecutter.slurm_partition }}
#SBATCH --qos={{ cookiecutter.slurm_qos }}
#SBATCH --mail-user={{ cookiecutter.email }}
#SBATCH --mail-type=END,FAIL


set -u
set -e

# set nextflow options for execution via slurm
export NXF_OPTS="-Xms500M -Xmx2G"
export NXF_ANSI_LOG=false

# install/update the pipeline
nextflow pull utia-gc/scrnaseq

# run pipeline
nextflow run utia-gc/scrnaseq \
    -revision main \
    -profile condo_trowan1,exploratory \
    -config config/nextflow.config \
    -params-file config/params_ngs.yaml
