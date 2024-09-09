/*
---------------------------------------------------------------------
    utia-gc/scrnaseq
---------------------------------------------------------------------
https://github.com/utia-gc/scrnaseq
*/

nextflow.enable.dsl=2

/*
---------------------------------------------------------------------
    RUN MAIN WORKFLOW
---------------------------------------------------------------------
*/

// Include custom workflows
include { CHECK_QUALITY      } from './workflows/check_quality.nf'
include { PREPARE_INPUTS     } from './workflows/prepare_inputs.nf'
include { PROCESS_READS      } from './workflows/process_reads.nf'
include { MAP_QUANTIFY_READS } from './workflows/map_quantify_reads.nf'

// Include plugin helper functions
include { paramsHelp; validateParameters } from 'plugin/nf-schema'

// Print help message with typical command line usage for the pipeline
if (params.help) {
    log.info paramsHelp('nextflow run utia-gc/scrnaseq -params-file params.yaml')
    exit 0
}

// Validate input parameters
validateParameters()

workflow {
    PREPARE_INPUTS(
        file(params.samplesheet),
        file(params.genome),
        file(params.annotations)
    )
    ch_reads_raw    = PREPARE_INPUTS.out.samples
    ch_reads_raw.dump(tag: "ch_reads_raw")
    ch_genome       = PREPARE_INPUTS.out.genome
    ch_genome_index = PREPARE_INPUTS.out.genome_index
    ch_annotations  = PREPARE_INPUTS.out.annotations

    PROCESS_READS(ch_reads_raw)
    ch_reads_pre_align = PROCESS_READS.out.reads_pre_align

    MAP_QUANTIFY_READS(
        ch_reads_pre_align,
        ch_genome,
        ch_annotations
    )
    ch_map_quantify_log = MAP_QUANTIFY_READS.out.map_quantify_log
    ch_map_quantify_log
        .dump(tag: 'ch_map_quantify_log', pretty: true)

    CHECK_QUALITY(
        ch_reads_raw,
        ch_genome_index,
        ch_map_quantify_log
    )
}
