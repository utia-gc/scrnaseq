workflow Parse_Design {
    take:
        samplesheet

    main:
        Channel
            .fromPath( samplesheet, checkIfExists: true )
            .splitCsv( header:true, sep:',' )
            .map { createSampleReadsChannel(it) }
            .set { ch_samples }

    emit:
        samples = ch_samples
}


// create a list of data from the csv
def createSampleReadsChannel(LinkedHashMap row) {
    // store metadata in a Map
    LinkedHashMap metadata = extractInfoFromSampleName(row.sampleName)
    metadata.readType   = row.reads2 ? "paired" : "single"

    // store reads in a list
    def reads = []
    if(metadata.readType == "single") {
        reads = [file(row.reads1)]
    } else {
        reads = [file(row.reads1), file(row.reads2)]
    }

    return [metadata, reads]
}


/**
 * Extract sample info from sample names that follow Illumina FASTQ file names.
 * 
 * @param sampleName The FASTQ sample name from the samplesheet.
 * @return LinkedHashMap of cleaned sample name, sample number, and lane.
 */
def extractInfoFromSampleName(String sampleName) {
    def match = sampleName =~ /^(.*)_S(\d+)_L(\d\d\d)/

    return [sampleName: match[0][1], sampleNumber: match[0][2], lane: match[0][3]]
}
