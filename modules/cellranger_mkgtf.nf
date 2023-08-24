process cellranger_mkgtf {
    label 'cellranger'

    input:
        path gtf

    output:
        path('*.gtf'), emit: gtf_filtered

    script:
        """
        cellranger mkgtf \
            ${gtf} \
            ${gtf.baseName}_filtered.gtf \
            --attribute=gene_biotype:protein_coding
        """
}
