/**
 *  Utilities for manipulating file names.
 */
class FileUtils {

    /**
     * Build a fastq filename that follows bcl2fastq conventions.
     *
     * @param metadata A metadata map.
     * @param readNumber The read number: 1 or 2.
     * @return String Conventional FastqName.
     */
    def static buildConventionalFastqName(LinkedHashMap metadata, String readNumber) {
        String sampleNumber = metadata.get('sampleNumber') ?: '0'
        String lane = metadata.get('lane') ?: '000'

        return "${metadata.sampleName}_S${sampleNumber}_L${lane}_R${readNumber}_001.fastq.gz"
    }

    /**
     * Check if a fastq name follows bcl2fastq conventions.
     *
     * @param fastqName A fastq file name.
     * @return Boolean Whether or not the fastq name follows bcl2fastq conventions.
     */
    def static isConventionalFastqName(String fastqName) {
        def conventionalFastqNamePattern = ~/^.*_S\d+_L\d{3}_[IR][12]_001\.fastq\.gz$/

        return fastqName ==~ conventionalFastqNamePattern
    }

}
