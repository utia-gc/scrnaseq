include { fastqc as fastqc_prealign   } from "../modules/fastqc.nf"
include { multiqc as multiqc_prealign } from "../modules/multiqc.nf"

workflow QC_Reads_Prealign {
    take:
        reads_prealign

    main:
        fastqc_prealign(reads_prealign)

        ch_multiqc_reads_prealign = Channel.empty()
            .concat(fastqc_prealign.out.zip)
            .collect( sort: true )

        multiqc_prealign(
            ch_multiqc_reads_prealign,
            "reads_prealign"
        )

    emit:
        multiqc = ch_multiqc_reads_prealign
}
