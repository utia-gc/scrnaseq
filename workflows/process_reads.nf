include { Cat_Reads  } from "../subworkflows/cat_reads.nf"

/**
 * Workflow to process reads.
 * Reads should be trimmed and concatenated here, if necessary.
 */

workflow PROCESS_READS {
    take:
        reads_raw

    main:
        Cat_Reads(reads_raw)

    emit:
        reads_pre_align = Cat_Reads.out.reads_catted
}
