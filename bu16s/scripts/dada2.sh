#!/bin/bash -l

#$ -P talbot-lab-data
#$ -j y#!/usr/bin/env bash

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

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
    cmd="qiime dada2 denoise-paired --p-trunc-len-f $DADA2_TRUNC_LEN --p-trunc-len-r $DADA2_TRUNC_LEN $dada2_params"
else
    cmd="qiime dada2 denoise-single --p-trunc-len $DADA2_TRUNC_LEN $dada2_params"
fi
echo --------------------------------------------------------------------------------------
echo $cmd
echo --------------------------------------------------------------------------------------
echo
eval $cmd
echo

# Add to run parameters
echo "export dada2_output=$dada2_output" >> $RUNPARAMETERS