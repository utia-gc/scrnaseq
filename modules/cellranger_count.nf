process cellranger_count {
    tag "${metadata.sampleName}"

    label 'cellranger'
    label 'big_mem'

    publishDir(
        path:    "${params.publishDirData}/quant/cellranger",
        mode:    "${params.publishMode}",
        pattern: "${metadata.sampleName}/outs"
    )

    input:
        tuple val(metadata), path(reads)
        path genome_index

    output:
        path("${metadata.sampleName}/outs"),                  emit: outs
        path("${metadata.sampleName}/outs/web_summary.html"), emit: web_summary

    script:
        String r1Name = FileUtils.isConventionalFastqName(reads[0].toString()) ? reads[0] : FileUtils.buildConventionalFastqName(metadata, '1')
        String r2Name = FileUtils.isConventionalFastqName(reads[1].toString()) ? reads[1] : FileUtils.buildConventionalFastqName(metadata, '2')

        """
        mkdir -p fastqs
        mv ${reads[0]} fastqs/${r1Name}
        mv ${reads[1]} fastqs/${r2Name}

        cellranger count \
            --id=${metadata.sampleName} \
            --fastqs=. \
            --transcriptome=. \
            --localcores=${task.cpus} \
            --localmem=${(task.memory as String).replaceAll(/\s[KMGT]?B/, '')}
        """
}
