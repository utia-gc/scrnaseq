process cellranger_count {
    tag "${metadata.sampleName}"

    label 'cellranger'
    label 'big_mem'

    input:
        tuple val(metadata), path(reads)
        path genome_index

    output:
        path("${metadata.sampleName}/outs"),                  emit: outs
        path("${metadata.sampleName}/outs/web_summary.html"), emit: web_summary

    script:
        """
        cellranger count \
            --id=${metadata.sampleName} \
            --fastqs=. \
            --transcriptome=. \
            --localcores=${task.cpus} \
            --localmem=${(task.memory as String).replaceAll(/\s[KMGT]?B/, '')}
        """
}
