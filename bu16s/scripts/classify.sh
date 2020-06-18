#!/bin/bash -l

#$ -P talbot-lab-data
#$ -j y#!/usr/bin/env bash

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

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

