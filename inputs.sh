# PIPELINE INPUTS
# THIS MUST BE UPDATED FOR YOUR PROJECT

# I/O **NO TRAILING SLASHES!
export PROJECTNAME=TEST
export INPUTDIR=/projectnb/talbot-lab-data/msilver/test_files
export OUTPUTDIR=/projectnb/talbot-lab-data/msilver/BU16s/test

export FWD_FMT=_1.fastq.gz
export REV_FMT=_2.fastq.gz

export FWD_PRIMER=GTGCCAGCMGCCGCGGTAA
export REV_PRIMER=GGACTACHVHHHTWTCTAAT
# PIPELINE PARAMETERS
# THESE SHOULD ONLY BE CHANGED FOR CHANGES TO CODE
export SCRIPTSDIR=/projectnb/talbot-lab-data/msilver/BU16s/bu16s/scripts
export SILVA_SEQUENCES=/projectnb/talbot-lab-data/msilver/ref_db/silva_132_99_16S.qza
export SILVA_TAXONOMY=/projectnb/talbot-lab-data/msilver/ref_db/silva_132_99_majority_taxonomy.qza