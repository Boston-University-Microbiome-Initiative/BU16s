#!/bin/bash

module load sratoolkit
fastq-dump SRR1927895 SRR1927866 --split-files --gzip -O test_files
