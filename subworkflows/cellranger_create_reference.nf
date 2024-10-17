include { cellranger_mkgtf } from '../modules/cellranger/cellranger_mkgtf'
include { cellranger_mkref } from '../modules/cellranger/cellranger_mkref'

/**
 * Create a Cell Ranger custom reference.
 * Filters GTF with `cellranger mkgtf` and builds reference with `cellranger mkref`.
 *
 * @param fasta The reference genome fasta file.
 * @param gtf The reference annotations GTF file.
 * @return genome_index Paths of genome indexes.
 */
workflow Cellranger_Create_Reference {
    take:
        fasta
        gtf

    main:
        // filter GTF
        cellranger_mkgtf(gtf)

        // build reference
        cellranger_mkref(
            fasta,
            cellranger_mkgtf.out.gtf_filtered
        )

    emit:
        genome_index = cellranger_mkref.out.genome_index
}
