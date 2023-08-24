include { Cellranger_Map_Count } from '../subworkflows/cellranger_map_count.nf'

/**
 * Workflow to map reads to a reference and quantify reads within features (genes/transcripts).
 *
 * Most (if not all) scRNA-seq pipelines I've seen take care of mapping and quantifying reads within the same step.
 * Both the index generation step ad mapping+quantification step should be taken care of here.
 * Ideally both these steps are wrapped up in a single subworkflow for each tool.
 * 
 * I choose to use the term quantify here because I think it better encapsulates both the pseudocounts/estimation employed Alevin/Kallisto as well as classical read counting methods.
 *
 * @param reads The reads to map.
 * @param genomeFasta The reference genome fasta file.
 * @param gtf The reference annotations GTF file.
 * @return map_quantify_log The log file from mapping and quantification that can be used as direct input for MultiQC.
 */
workflow MAP_COUNT_READS {
    take:
        reads
        genomeFasta
        gtf

    main:
        Cellranger_Map_Count(
            reads,
            genomeFasta,
            gtf
        )

    emit:
        map_quantify_log = Cellranger_Map_Count.out.map_count_log
}
