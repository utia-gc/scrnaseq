#!/usr/bin/env bash

readonly params_docs_path="docs/pipeline_config/params.md"

# build the docs page from the nf-schema (nf-validate) nextflow_schema.json file
uvx nf-core@3.3.1 pipelines schema docs --output "${params_docs_path}" --force

# replace the params docs file header with just "Params"
sed -i 's|utia-gc/scrnaseq pipeline parameters|Params|g' "${params_docs_path}"
