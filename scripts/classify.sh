#!/bin/bash -l

### CONSENSUS CLASSIFICATION OF SEQUENCES ###

#$ -j y#!/usr/bin/env bash

PARAMETERS=$1
source $PARAMETERS
source $RUNPARAMETERS

classification_output=$INTERMEDIATEDIR/"$PROJECTNAME"_SILVA99.qza
cmd="qiime feature-classifier classify-consensus-vsearch \
--i-query $dada2_output/representative_sequences.qza \
--i-reference-reads $SILVA_SEQUENCES \
--i-reference-taxonomy $SILVA_TAXONOMY \
--p-threads $(nproc --all) \
--p-top-hits-only True \
--p-perc-identity 0.95 \
--p-maxrejects 100 \
--p-maxaccepts all \
--verbose \
--o-classification $classification_output"
echo --------------------------------------------------------------------------------------
echo $cmd
echo --------------------------------------------------------------------------------------
eval $cmd
echo

# Add to run parameters
echo "export classification_output=$classification_output" >> $RUNPARAMETERS

# Extract taxonomy
qiime tools export --input-path $classification_output --output-path $OUTPUTDIR
consensus_out=$OUTPUTDIR/"$PROJECTNAME"_consensus.tsv
mv $OUTPUTDIR/taxonomy.tsv $consensus_out
echo
echo -e "\e[32mSaved Consensus Classification to: $consensus_out\e[0m"
