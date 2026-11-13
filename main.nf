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
include { validateParameters } from 'plugin/nf-schema'

// Validate input parameters
validateParameters()

workflow {
    main:
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

        PROCESS_READS(
            ch_reads_raw,
            params.mapQuantTool,
        )
        ch_readsPrealign = PROCESS_READS.out.readsPrealign

        ch_sample_list = params.sampleList ? file(params.sampleList) : Channel.empty()
        MAP_QUANTIFY_READS(
            ch_readsPrealign,
            ch_genome,
            ch_annotations,
            ch_sample_list,
            params.mapQuantTool
        )
        ch_mapQuantifyLog = MAP_QUANTIFY_READS.out.mapQuantifyLog
        ch_mapQuantifyLog
            .dump(tag: 'ch_mapQuantifyLog', pretty: true)

        CHECK_QUALITY(
            ch_reads_raw,
            ch_genome_index,
            ch_mapQuantifyLog,
            "${params.projectTitle}"
        )
}
