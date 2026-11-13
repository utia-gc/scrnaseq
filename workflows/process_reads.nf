include { cat_fastq } from '../modules/cat_fastq.nf'
include { Group_Reads } from '../subworkflows/group_reads.nf'

/**
 * Workflow to process reads.
 * Reads should be trimmed and concatenated here, if necessary.
 * @param mapQuantifyTool The tool for mapping and quantification.
 */
workflow PROCESS_READS {
    take:
    readsRaw
    mapQuantifyTool

    main:
    if (mapQuantifyTool.toUpperCase() == 'CELLRANGER') {
        ch_readsGrouped = Group_Reads(readsRaw)
        ch_readsCatted = cat_fastq(ch_readsGrouped)
        ch_readsPrealign = ch_readsCatted
    }
    else if (mapQuantifyTool.toUpperCase() == 'SPLIT_PIPE') {
        ch_readsGrouped = Group_Reads(readsRaw)
        ch_readsPrealign = ch_readsGrouped
    }

    emit:
    readsPrealign = ch_readsPrealign
}
