# python /projectnb/talbot-lab-data/msilver/BU16s/create_inputs.py --input_dir test_files --output_dir test --project TEST --fwd _1.fastq.gz --rev _2.fastq.gz
export PROJECTNAME=TEST
export INPUTDIR=/projectnb2/talbot-lab-data/msilver/BU16s/test_files
export OUTPUTDIR=/projectnb2/talbot-lab-data/msilver/BU16s/test
export INTERMEDIATEDIR=/projectnb2/talbot-lab-data/msilver/BU16s/test/intermediate
export RUNPARAMETERS=/projectnb2/talbot-lab-data/msilver/BU16s/test/.runparams
export FWD_FMT=_1.fastq.gz
export REV_FMT=_2.fastq.gz
export FWD_PRIMER=GTGCCAGCMGCCGCGGTAA
export REV_PRIMER=GGACTACHVHHHTWTCTAAT
export DADA2_TRUNC_LEN_F=0
export DADA2_TRUNC_LEN_R=0
export PAIRED=True
export SCRIPTSDIR=/projectnb/talbot-lab-data/msilver/BU16s/bu16s/scripts
export SILVA_SEQUENCES=/projectnb/talbot-lab-data/msilver/ref_db/silva_132_99_16S.qza
export SILVA_TAXONOMY=/projectnb/talbot-lab-data/msilver/ref_db/silva_132_99_majority_taxonomy.qza
export CONDA_ENV=/projectnb/talbot-lab-data/msilver/.conda/envs/qiime2-2020.2
# Load modules and inputs
module purge
module load miniconda
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
conda activate $CONDA_ENV