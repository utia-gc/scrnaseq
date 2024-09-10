process split_pipe_mkref {
    tag "${fasta.baseName}"

    // Process settings label
    label 'split_pipe'

    // Resources labels
    label 'huge_cpu'
    label 'huge_mem'
    label 'med_time'

    input:
        path fasta
        path gtf

    output:
        path('split-pipe-mkref/*'), emit: genome_index

    script:
        """
        split-pipe \\
            --mode mkref \\
            --nthreads ${task.cpus} \\
            --genome_name ${fasta.baseName} \\
            --fasta "${fasta}" \\
            --genes "${gtf}" \\
            --output_dir split-pipe-mkref
        """
}
