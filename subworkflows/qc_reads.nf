include { compute_bases_genome     } from '../modules/compute_bases_genome.nf'
include { compute_bases_reads      } from '../modules/compute_bases_reads.nf'
include { fastqc                   } from '../modules/fastqc.nf'
include { multiqc as multiqc_reads } from '../modules/multiqc.nf'
include { Group_Reads              } from '../subworkflows/group_reads.nf'


workflow QC_Reads {
    take:
        reads_raw
        genome_index

    main:
        fastqc(reads_raw)

        compute_bases_genome(genome_index)
        ch_bases_genome = compute_bases_genome.out.bases

        // Count bases in raw reads
        Group_Reads(reads_raw)
        compute_bases_reads(Group_Reads.out.reads_grouped)
        // Compute sequencing depth for raw reads
        // Sequencing depth = total number of bases in reads for a sample / total number of bases in the reference genome
        compute_bases_reads.out.bases
            .combine(ch_bases_genome)
            .map { metadata, basesInReads, basesInGenome ->
                [ metadata, Long.valueOf(basesInReads) / Long.valueOf(basesInGenome) ]
            }
            // write sequencing depth to a file for input to MultiQC
            .collectFile() { metadata, depth ->
                [
                    "${metadata.sampleName}_raw_seq-depth.tsv",
                    "Sample Name\tDepth\n${metadata.sampleName}\t${depth}"
                ]
            }
            .set { ch_sequencing_depth_raw }

        ch_multiqc_reads = Channel.empty()
            .concat(fastqc.out.zip)
            .concat(ch_sequencing_depth_raw)
            .collect()

        multiqc_reads(
            ch_multiqc_reads,
            file("${projectDir}/assets/multiqc_config.yaml"),
            "reads"
        )

    emit:
        multiqc = ch_multiqc_reads
}
