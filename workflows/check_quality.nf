include { QC_Reads                        } from '../subworkflows/qc_reads.nf'
include { multiqc as multiqc_map_quantify } from "../modules/multiqc.nf"
include { multiqc as multiqc_full         } from "../modules/multiqc.nf"


workflow CHECK_QUALITY {
    take:
        reads_raw
        genome_index
        map_quantify_log

    main:
        QC_Reads(
            reads_raw,
            genome_index
        )
        ch_multiqc_reads = QC_Reads.out.multiqc

        multiqc_map_quantify(
            map_quantify_log,
            file("${projectDir}/assets/multiqc_config.yaml"),
            'map_quantify'
        )

        ch_multiqc_full = Channel.empty()
            .concat(ch_multiqc_reads)
            .concat(map_quantify_log)
            .collect( sort: true )
        multiqc_full(
            ch_multiqc_full,
            file("${projectDir}/assets/multiqc_config.yaml"),
            params.projectTitle
        )
}
