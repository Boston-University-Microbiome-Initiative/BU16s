#!/bin/bash

module load sratoolkit
fastq-dump SRR7721323 SRR7721324 --split-files --gzip -O test_files
