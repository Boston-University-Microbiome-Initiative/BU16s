#!/bin/bash -l

### CLUSTERS ASVs TO SILVA99 OTUs ###

#$ -j y#!/usr/bin/env bash

PARAMETERS=$1
source $PARAMETERS
source $RUNPARAMETERS

vsearch_outdir=$INTERMEDIATEDIR/vsearch

# Delete directoy if already exists
if [ -d $vsearch_outdir ]
then
    rm -rf $vsearch_outdir
fi

cmd="qiime vsearch cluster-features-closed-reference \
 --i-sequences $dada2_output/representative_sequences.qza \
 --i-table $dada2_output/table.qza \
 --i-reference-sequences $SILVA_SEQUENCES \
 --p-perc-identity .99 \
 --p-strand both \
 --p-threads $(nproc --all) \
 --output-dir $vsearch_outdir \
 --verbose"

echo --------------------------------------------------------------------------------------
echo $cmd
echo --------------------------------------------------------------------------------------
echo
eval $cmd
echo

# Extract OTU table
qiime tools export --input-path $vsearch_outdir/clustered_table.qza --output-path $vsearch_outdir
# Convert to tsv and remove stupid header
biom convert -i $vsearch_outdir/feature-table.biom -o $vsearch_outdir/feature-table.tsv --to-tsv
otu_out=$OUTPUTDIR/"$PROJECTNAME"_SILVA99.tsv
sed '1d' $vsearch_outdir/feature-table.tsv > $otu_out
echo
echo -e "\e[32mSaved OTU table to: $otu_out\e[0m"

# Add to run parameters
echo "export vsearch_output=$vsearch_outdir" >> $RUNPARAMETERS