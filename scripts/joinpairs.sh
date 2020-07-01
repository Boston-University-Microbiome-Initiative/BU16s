#!/bin/bash -l

#$ -P talbot-lab-data
#$ -j y#!/usr/bin/env bash

PARAMETERS=$1
source $PARAMETERS
source $RUNPARAMETERS

qiime vsearch join-pairs \
--i-demultiplexed-seqs $=$demux_artifact \

