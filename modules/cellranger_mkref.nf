process cellranger_mkref {
    // Process settings label
    label 'cellranger'

    // Resources labels
    label 'huge_cpu'
    label 'huge_mem'
    label 'med_time'

    input:
        path fasta
        path gtf

    output:
        path("${fasta.baseName}/*"), emit: genome_index

    script: 
        """
        cellranger mkref \
            --genome=${fasta.baseName} \
            --fasta=${fasta} \
            --genes=${gtf} \
            --memgb=${(task.memory as String).replaceAll(/\s[KMGT]?B/, '')} \
            --nthreads=${task.cpus}
        """
}
