process split_pipe_all {
    tag "${metadata.sampleName}"

    // Process settings label
    label 'split_pipe'

    // Resources labels
    label 'sup_cpu'
    label 'huge_mem'
    label 'max_time'

    input:
        tuple val(metadata), path(reads1), path(reads2)
        path index
        path sampleList

    output:
        tuple val(metadata), path("${metadata.sampleName}"), emit: outs

    script:
        String args = new Args(task.ext).buildArgsString()

        """
        split-pipe \\
            --mode all \\
            --nthreads "${task.cpus}" \\
            --genome_dir "${index}" \\
            --fq1 "${reads1}" \\
            --fq2 "${reads2}" \\
            --samp_list "${sampleList}" \\
            --output_dir "${metadata.sampleName}" \\
            ${args}
        """
}
