process split_pipe_comb{
    // Process settings label
    label 'split_pipe'

    // Resources labels
    label 'big_cpu'
    label 'big_mem'
    label 'bit_time'

    // Publish data
    publishDir(
        path:    "${params.publishDirData}/quant/split-pipe",
        mode:    "${params.publishMode}",
        pattern: "*"
    )
    // Publish reports
    publishDir(
        path:    "${params.publishDirReports}/quant/split-pipe",
        mode:    "${params.publishMode}",
        pattern: "*analysis_summary.{csv,html}"
    )

    input:
        path(sublibraries)

    output:
        path('combined'), emit: combinedOuts

    script:
        String args = new Args(task.ext).buildArgsString()

        """
        split-pipe \\
            --mode comb \\
            --nthreads "${task.cpus}" \\
            --sublibraries ${sublibraries} \\
            --output_dir combined \\
            ${args}
        """
}
