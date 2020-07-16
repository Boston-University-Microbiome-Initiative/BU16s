#!/bin/bash -l

### TRIMS PRIMERS ###

#$ -j y#!/usr/bin/env bash

PARAMETERS=$1
source $PARAMETERS
source $RUNPARAMETERS

trim_output=$INTERMEDIATEDIR/"$PROJECTNAME"_trimmed.qza
if [ $PAIRED == "True" ]
then
    trim_setting="trim-paired"
    if [ $PRIMER_END == "5" ]
    then
        front_option="p-front-f"
        rev_option="p-front-r"
    else
        front_option="p-adapter-f"
        rev_option="p-adapter-r"
    fi
else
    trim_setting="trim-single"
    rev_option="p-anywhere"
    if [ $PRIMER_END == "5" ]
    then
        front_option="p-front"
    else
        front_option="p-adapter"
    fi
fi

cmd="qiime cutadapt $trim_setting \
    --i-demultiplexed-sequences $demux_artifact \
    --$front_option $FWD_PRIMER \
    --$rev_option $REV_PRIMER \
    --p-times 2 \
    --p-match-read-wildcards True \
    --p-match-adapter-wildcards True \
    --p-minimum-length 50 \
    --p-cores $(nproc --all) \
    --verbose \
    --o-trimmed-sequences $trim_output \
    $CUTADAPT_ARGS"
echo --------------------------------------------------------------------------------------
echo $cmd
echo --------------------------------------------------------------------------------------
echo
eval $cmd
echo

# Add to run parameters
echo "export trim_output=$trim_output" >> $RUNPARAMETERS