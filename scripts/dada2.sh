#!/bin/bash -l

### GENERATES ASVs WITH DADA2 ###

#$ -j y#!/usr/bin/env bash

PARAMETERS=$1
source $PARAMETERS
source $RUNPARAMETERS

dada2_output=$INTERMEDIATEDIR/dada2
# Delete directoy if already exists
if [ -d $dada2_output ]
then
    rm -rf $dada2_output
fi
dada2_params="--i-demultiplexed-seqs $trim_output \
    --p-n-threads 0 \
    --verbose \
    --output-dir $dada2_output"
if [ $PAIRED == "True" ]
then
    cmd="qiime dada2 denoise-paired --p-trunc-len-f $DADA2_TRUNC_LEN_F --p-trunc-len-r $DADA2_TRUNC_LEN_R $dada2_params $DADA2_ARGS"
else
    cmd="qiime dada2 denoise-single --p-trunc-len $DADA2_TRUNC_LEN_F $dada2_params $DADA2_ARGS"
fi
echo --------------------------------------------------------------------------------------
echo $cmd
echo --------------------------------------------------------------------------------------
echo
eval $cmd
echo

# Export denoising stats
qiime tools export --input-path $dada2_output/denoising_stats.qza --output-path $dada2_output

# Extract ASV table
qiime tools export --input-path $dada2_output/table.qza --output-path $dada2_output
# Convert to tsv and remove stupid header
biom convert -i $dada2_output/feature-table.biom -o $dada2_output/feature-table.tsv --to-tsv
asv_out=$OUTPUTDIR/"$PROJECTNAME"_ASV.tsv
sed '1d' $dada2_output/feature-table.tsv > $asv_out
echo -e "\e[32mSaved ASV table to: $asv_out\e[0m"

# Add to run parameters
echo "export dada2_output=$dada2_output" >> $RUNPARAMETERS
