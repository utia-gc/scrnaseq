include { Cellranger_Map_Count } from '../subworkflows/cellranger_map_count.nf'

include { split_pipe_all   } from '../modules/split-pipe/split_pipe_all'
include { split_pipe_comb  } from '../modules/split-pipe/split_pipe_comb'
include { split_pipe_mkref } from '../modules/split-pipe/split_pipe_mkref'

/**
 * Workflow to map reads to a reference and quantify reads within features (genes/transcripts).
 *
 * Most (if not all) scRNA-seq pipelines I've seen take care of mapping and quantifying reads within the same step.
 * Both the index generation step ad mapping+quantification step should be taken care of here.
 * Ideally both these steps are wrapped up in a single subworkflow for each tool.
 * 
 * I choose to use the term quantify here because I think it better encapsulates both the pseudocounts/estimation employed Alevin/Kallisto as well as classical read counting methods.
 *
 * @param reads The reads to map.
 * @param genomeFasta The reference genome fasta file.
 * @param gtf The reference annotations GTF file.
 * @param sampleList The samples list for Parse split-pipe.
 * @param map_quantify_tool The tool for mapping and quantification.
 * @return map_quantify_log The log file from mapping and quantification that can be used as direct input for MultiQC.
 */
workflow MAP_QUANTIFY_READS {
    take:
        reads
        genomeFasta
        gtf
        sampleList
        map_quantify_tool

    main:
        switch ( map_quantify_tool.toUpperCase() ) {
            case 'CELLRANGER':
                Cellranger_Map_Count(
                    reads,
                    genomeFasta,
                    gtf
                )
                ch_map_quantify_log = Cellranger_Map_Count.out.map_count_log
                break

            case 'SPLIT_PIPE':
                split_pipe_mkref(
                    genomeFasta,
                    gtf
                )
                split_pipe_all(
                    reads.map { meta, reads ->
                        return [ meta, reads[0], reads[1] ]
                    },
                    split_pipe_mkref.out.genome_index,
                    sampleList
                )

                // combine outputs from multiple sublibraries
                // collect each individual sublibrary into a list of sublibraries
                split_pipe_all.out.outs
                    .collect(
                        // get sublibrary only -- lose the metadata
                        { metadata, sublibrary ->
                            return sublibrary
                        },
                        // sort based on file name
                        sort: { a, b ->
                            a.name <=> b.name
                        }
                    )
                    .set { ch_parse_sublibraries }
                split_pipe_comb(ch_parse_sublibraries)

                ch_map_quantify_log = Channel.empty()
                break
        }

    emit:
        map_quantify_log = ch_map_quantify_log
}
