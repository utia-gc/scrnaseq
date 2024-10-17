include { cellranger_count            } from '../modules/cellranger/cellranger_count'
include { Cellranger_Create_Reference } from '../subworkflows/cellranger_create_reference.nf'

workflow Cellranger_Map_Count {
    take:
        reads
        fasta
        gtf

    main:
        // build Cell Ranger reference
        Cellranger_Create_Reference(
            fasta,
            gtf
        )

        // run Cell Ranger count pipeline
        cellranger_count(
            reads,
            Cellranger_Create_Reference.out.genome_index
        )

    emit:
        map_count_log = cellranger_count.out.web_summary
}
