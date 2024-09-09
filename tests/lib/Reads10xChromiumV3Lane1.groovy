import groovy.transform.InheritConstructors

@InheritConstructors
class Reads10xChromiumV3Lane1 extends Reads {
    LinkedHashMap metadata = [
        sampleName:   'Chromium_3p_GEX_Human_PBMC_chr21_100000',
        lane:         '001',
        readType:     'paired'
    ]
    List reads = [
        'tests/data/data/reads/raw/Chromium_3p_GEX_Human_PBMC_chr21_100000_S1_L001_R1_001.fastq.gz',
        'tests/data/data/reads/raw/Chromium_3p_GEX_Human_PBMC_chr21_100000_S1_L001_R2_001.fastq.gz'
    ]
}
