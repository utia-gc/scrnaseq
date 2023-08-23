process cellranger_mkref {
    label 'cellranger'
    
    label 'big_mem'

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
