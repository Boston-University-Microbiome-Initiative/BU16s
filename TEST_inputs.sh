# python /projectnb/microbiome/BU16s/create_inputs.py --input_dir test_files --output_dir test --project TEST --fwd _1.fastq.gz --rev _2.fastq.gz --fprimer ACACTGACGACATGGTTCTACAGTGCCAGCMGCCGCGGTAA --rprimer TACGGTAGCAGAGACTTGGTCTGGACTACHVGGGTWTCTAAT
export PROJECTNAME=TEST
export INPUTDIR=/projectnb2/microbiome/BU16s/test_files
export OUTPUTDIR=/projectnb2/microbiome/BU16s/test
export INTERMEDIATEDIR=/projectnb2/microbiome/BU16s/test/intermediate
export RUNPARAMETERS=/projectnb2/microbiome/BU16s/test/.runparams
export FWD_FMT=_1.fastq.gz
export REV_FMT=_2.fastq.gz
export FWD_PRIMER=ACACTGACGACATGGTTCTACAGTGCCAGCMGCCGCGGTAA
export REV_PRIMER=TACGGTAGCAGAGACTTGGTCTGGACTACHVGGGTWTCTAAT
export PRIMER_END=5
export DADA2_TRUNC_LEN_F=0
export DADA2_TRUNC_LEN_R=0
export CUTADAPT_ARGS=""
export DADA2_ARGS=""
export PAIRED=True
export SCRIPTSDIR=/projectnb/microbiome/BU16s/scripts
export SILVA_SEQUENCES=/projectnb/microbiome/ref_db/silva_132_99_16S.qza
export SILVA_TAXONOMY=/projectnb/microbiome/ref_db/silva_132_99_majority_taxonomy.qza
# Load modules and inputs
module purge
module load miniconda/4.7.5
module load qiime2/2020.2
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
conda activate $SCC_QIIME2_DIR
