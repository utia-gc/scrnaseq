process cellranger_mkgtf {
    // Process settings label
    label 'cellranger'

    // Resources labels
    label 'def_cpu'
    label 'lil_mem'
    label 'lil_time'

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
