# Params

A Nextflow pipeline for base NGS analysis.

## Input/output options

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `projectTitle` | A short title for the project. Used in naming files/directories. | `string` |  | True |  |
| `samplesheet` | Path to input samplesheet in CSV format. | `string` |  | True |  |
| `sampleList` | Sample list for input to Parse split-pipe | `string` |  |  |  |
| `genome` | A path or URL to the reference genome sequence file in fasta format. <details><summary>Help</summary><small>For reasons of reproducibility and portability we recommend using direct links to reference genome sequence files available through repositories such as RefSeq and Ensembl.</small></details>| `string` |  | True |  |
| `annotations` | A path or URL to the reference genome annotations file in GTF format. <details><summary>Help</summary><small>For reasons of reproducibility and portability we recommend using direct links to reference annotation files available through repositories such as RefSeq and Ensembl.</small></details>| `string` |  | True |  |
| `publishDirData` | Base directory in which output data files will be published. <details><summary>Help</summary><small>We think of this pipeline as producing as producing two main types of output: data and reports. Data files are raw or processed files that are used for generating results and insights. They typically are not immediately interpretable by humans and often are not even human readable.<br><br>Examples of data files would include raw fastq files, mappings in BAM format, tables of read counts within genes.</small></details>| `string` | ${launchDir}/data |  |  |
| `publishDirReports` | Base directory in which output reports files will be published. <details><summary>Help</summary><small>We think of this pipeline as producing as producing two main types of output: data and reports. Reports files are processed files that are used for immediately producing insights. They typically immediately interpretable by humans.<br><br>Examples of reports files would include MultiQC reports and MultiQC data tables, summary statistics files produced by Samtools stats, etc.</small></details>| `string` | ${launchDir}/reports |  |  |
| `publishMode` | Method for publishing files. <details><summary>Help</summary><small>This sets the default mode for publishing files. See the `mode` section of the [`publishDir` Nextflow docs](https://www.nextflow.io/docs/latest/process.html#publishdir) for details about the options.</small></details>| `string` | copy |  |  |

## Mapping and quantification parameters

| Parameter | Description | Type | Default | Required | Hidden |
|-----------|-----------|-----------|-----------|-----------|-----------|
| `mapQuantTool` | Tool for mapping and quantifying reads. | `string` | cellranger | True |  |
