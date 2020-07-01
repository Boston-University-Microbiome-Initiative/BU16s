#!/bin/bash -l

#$ -P talbot-lab-data
#$ -j y#!/usr/bin/env bash

PARAMETERS=$1
source $PARAMETERS
source $RUNPARAMETERS

module load vsearch

trunc_output=$INTERMEDIATEDIR/trunc
if [ -d $trunc_output ]
then
    rm -rf $trunc_output
fi
mkdir $trunc_output

fwd_reads=$(ls $INPUTDIR/*$FWD_FMT)

# Truncate forward reads or move them to trunc directory if no truncation
if [ $TRUNC_LEN_F -gt 0 ]
then
    echo "Truncating forward reads"
    for f in $fwd_reads
    do
        b=$(basename $f)
        sample=${b%$FWD_FMT}
        outpath=$trunc_output/"$sample"_trunc"$FWD_FMT"
        cmd="vsearch -fastq_filter $f -fastqout $outpath -fastq_trunclen $TRUNC_LEN_F"
        echo $cmd
        eval $cmd
    done
else
    echo "Not truncating forward reads"
    for f in $fwd_reads
    do
        b=$(basename $f)
        sample=${b%$FWD_FMT}
        outpath=$trunc_output/"$sample"_trunc"$FWD_FMT"
        cp $f $outpath
    done
fi

# Truncate reverse reads
rev_reads=$(ls $INPUTDIR/*$REV_FMT)
if [ $PAIRED == True ]
then
    if [ $TRUNC_LEN_R -gt 0 ]
    then
        echo "Truncating reverse reads"
        for f in $rev_reads
        do
            b=$(basename $f)
            sample=${b%$REV_FMT}
            outpath=$trunc_output/"$sample"_trunc"$REV_FMT"
            cmd="vsearch -fastq_filter $f -fastqout $outpath -fastq_trunclen $TRUNC_LEN_R"
            echo $cmd
            eval $cmd
        done

    else
        echo "Not truncating reverse reads"
        for f in $rev_reads
        do
            b=$(basename $f)
            sample=${b%$REV_FMT}
            outpath=$trunc_output/"$sample"_trunc"$REV_FMT"
            cp $f $outpath
        done
    fi
fi

# Add to run parameters
echo "export trunc_output=$trunc_output" >> $RUNPARAMETERS