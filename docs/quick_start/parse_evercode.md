# Parse Biosciences Evercode

## Problem

How do I run the `{{ pipeline.name }}` to process a Parse Biosciences Evercode dataset?

There are a variety of scRNAseq technologies and platforms which are often analyzed by different tools.
We have designed `{{ pipeline.name }}` to process Parse Biosciences Evercode scRNAseq libraries.

## Solution

Parse Biosciences makes its tool [split-pipe](https://support.parsebiosciences.com/hc/en-us/sections/360011218152-Running-the-command-line-pipeline-basic) available to its customers for processing libraries generated using its single-cell platform.
We have added split-pipe as an option to `{{ pipeline.name }}` for processing Parse single-cell libraries.

Like many single-cell data processing tools, split-pipe is an all-in-one pipeline for read trimming, mapping, and quantification alongside some QC.
When used to run split-pipe, `{{ pipeline.name }}` largely acts as a wrapper around split-pipe for additional QC and efficient execution.

!!! info Access for Parse customers only

    split-pipe and its documentation are available for Parse Biosciences customers only.
    You may need to reach out to the Parse team for access to view the page at the link above.


## Usage

!!! warning Restricted access to split-pipe

    Parse has a limited use license for split-pipe.
    We have received special permission from Parse to containerize split-pipe and host the image on a private container registry for use in `{{ pipeline.name }}`.
    Users without privileged access will not be able to run split-pipe in `{{ pipeline.name }}`.
    Please contact the pipeline maintainers either for access to the container registry or to have them run the pipeline for you.

    Advanced users may acquire their own copy of split-pipe and configure their pipeline run to use their copy of the software.
    Please be mindful of Parse's software licenses if you choose this route.

### Overview

Processing single-cell data produced with the Parse Biosciences Evercode kit with split-pipe is straightforward in `{{ pipeline.name }}`:

- Configure the project title and reference options by setting the `params.projectTitle`, `params.genome`, and `params.annotations` as usual.
- Construct a samplesheet for the parse sublibraries as you would for any other pipeline run and configure the pipeline run to use the samplesheet with the `params.samplesheet`.
- Configure the pipeline run to use split-pipe as the mapping and quantification tool: set `params.mapQuantTool = "split_pipe"`.
- Create a [sample list file](#sample-list-file) to be supplied to split-pipe `--samp_list` argument, and configure the pipeline run to use this file: `params.sampleList = "<path/to/sample-list.txt>"`.

### Example

!!! note This is not a working example.

    It is for demsontration only.

Create the samplesheet.
Each Parse sublibrary + lane gets its own line.

```csv title="config/samplesheet/samplesheet.csv"
sampleName,lane,reads1,reads2
utiagcaa000001_sublib1,001,/path/to/utiagcaa000001_sublib1_L001_R1_001.fastq.gz,/path/to/utiagcaa000001_sublib1_L001_R2_001.fastq.gz
utiagcaa000001_sublib1,002,/path/to/utiagcaa000001_sublib1_L002_R1_001.fastq.gz,/path/to/utiagcaa000001_sublib1_L002_R2_001.fastq.gz
utiagcaa000001_sublib1,003,/path/to/utiagcaa000001_sublib1_L003_R1_001.fastq.gz,/path/to/utiagcaa000001_sublib1_L003_R2_001.fastq.gz
utiagcaa000001_sublib1,004,/path/to/utiagcaa000001_sublib1_L004_R1_001.fastq.gz,/path/to/utiagcaa000001_sublib1_L004_R2_001.fastq.gz
utiagcaa000002_sublib2,001,/path/to/utiagcaa000002_sublib2_L001_R1_001.fastq.gz,/path/to/utiagcaa000002_sublib2_L001_R2_001.fastq.gz
utiagcaa000002_sublib2,002,/path/to/utiagcaa000002_sublib2_L002_R1_001.fastq.gz,/path/to/utiagcaa000002_sublib2_L002_R2_001.fastq.gz
utiagcaa000002_sublib2,003,/path/to/utiagcaa000002_sublib2_L003_R1_001.fastq.gz,/path/to/utiagcaa000002_sublib2_L003_R2_001.fastq.gz
utiagcaa000002_sublib2,004,/path/to/utiagcaa000002_sublib2_L004_R1_001.fastq.gz,/path/to/utiagcaa000002_sublib2_L004_R2_001.fastq.gz
```

Create the sample list file.

```txt title="config/samplesheet/sample-list.txt
utiagcaa001000 A1,A2
utiagcaa001001 A3-A6
```

Create the params YAML file.

```yaml title="config/nextflow/params_scrnaseq.yaml"
projectTitle: "utia-gc_scrnaseq_example"
genome: "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/772/045/GCF_016772045.2_ARS-UI_Ramb_v3.0/GCF_016772045.2_ARS-UI_Ramb_v3.0_genomic.fna.gz"
annotations: "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/772/045/GCF_016772045.2_ARS-UI_Ramb_v3.0/GCF_016772045.2_ARS-UI_Ramb_v3.0_genomic.gtf.gz"
samplesheet: "config/samplesheet/samplesheet.csv"
sampleList: "config/samplesheet/sample-list.txt"
mapQuantTool: "split_pipe"
```

Run the pipeline.

```bash
nextflow run utia-gc/scrnaseq \
    -revision {{ pipeline.revision }} \
    -params-file config/nextflow/params_scrnaseq.yaml
```

### Details

#### Sample list file

The sample list file maps sample names to well IDs.
Multiple samples may be defined but wells must uniquely map to samples (i.e. wells cannot be specified as part of more than one sample).
The file is space delimited and comprises two columns with no headers:

1. Sample name.
2. Well IDs. This may be a single well (e.g. A2), an explicit comma separated list of wells (A3,A4,A6), or a range of wells (A8-A12).

!!! quote `split-pipe --explain` sample well format section

    Specifying sample well format

    --sample <name> <wells>

    Samples are specified by <name> and <wells>

    Wells are specified individually or in blocks or ranges like this:
        'C4' specifies a single well.
        'A1:C6' specifies a block as [top-left]:[bottom-right]; 'A1-A6,B1-B6,C1-C6'
        'A1-B6' specifies a range as [start]-[end]; 'A1-A12,B1-6'
        Multiple selections are joined by commas (NO SPACES), e.g. 'A1-A6,B1:D3,C4'

    Valid sample wells depend on kit

    If more than one 96-well plate is available for a barcoding round, this is
        specified with a "pN." prefix, where N is the plate number. For example,
        this block specifies 3 cols across two plates: 'A4:p2.H6' (16 rows, 48 wells).
    If two barcode rounds are used for sample specification, wells are specified
        for each round, and then joined via underscores; For example 'B5__A1:H3'
    Sample well notation can be replaced by well number, with numbers as 1-12 for
        row 'A', 13-24 for row 'B', etc. For kits with 384 samples, numbers range
        1-384 across 4 (round 1) plates. For example, numbers 97 and 384 denote
        wells 'p2.A1' and 'p4.H12', respectively.

    Sample names must be unique and cannot be ambiguous with respect to wells; If a
        sample is named as a well, it is prepended like 'd4' >--> 'sample_d4'.

    Sample specification may be supplied via --sample, --samp_list, or --samp_sltab.

!!! info Specifying samples to split-pipe in `{{ pipeline.name }}`

    split-pipe makes several methods available for supplying the sample specification.
    However, `{{ pipeline.name }}` requires the sample list file to be specified.
    The pipeline run will fail otherwise.

#### Additional configuration

Parse Biosciences chemistry and kit are set at the pipeline run level.
This means that all sublibraries in a run are treated as the same chemistry and kit.

!!! note Kit and chemistry defaults

    Kit and chemistry default values are set in the [pipeline arguments config file](https://github.com/{{ pipeline.name }}/blob/{{ pipeline.revision }}/conf/args.config).
    These default values may change depending on which kit the UTIA Genomics Center is using as its default kit at the time.
