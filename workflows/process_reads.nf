include { Trim_Reads } from "../subworkflows/trim_reads.nf"

/**
 * Workflow to process reads.
 * Reads should be trimmed and concatenated here, if necessary.
 */

workflow PROCESS_READS {
    take:
        reads_raw

    main:
        if(!params.skipTrimReads) {
            Trim_Reads(
                reads_raw,
                params.tools.trim
            )
            ch_reads_trim = Trim_Reads.out.reads_trim
            ch_trim_log   = Trim_Reads.out.trim_log
        } else {
            ch_reads_trim = Channel.empty()
            ch_trim_log   = Channel.empty()
        }

    emit:
        reads_pre_align = ch_reads_trim
        trim_log        = ch_trim_log
}
