# BU Amplicon Sequencing Pipeline
Amplicon sequence processing pipeline that utilizes Boston University's SCC to process raw amplicon (16S, ITS, etc.) sequences into ASVs and OTUs. Uses QIIME2 with cutadapt to trim primers, dada2 to generate ASVs, and clusters ASVs to SILVA99 with vsearch.

# Set up
There is no installation. The code exists in the SCC.

To load the pipeline, run the following in a SCC terminal:
```bash
module load bu16s
```

Pipeline jobs are submitted using [bu16s.qsub](bu16s.qsub) with an inputs file as argument. Input files are generated with [create_inputs.py](create_inputs.py) - use `create_inputs.py -h` to view arguments.

The classification of SILVA OTUs is at: `/projectnb/microbiome/BU16s/ref_db/SILVA_132_QIIME_release/taxonomy/16S_only/99/consensus_taxonomy_7_levels.txt`
# Tutorial
## 1. Download test data
Create a test directory and run the following command to download two small FASTQ files to `test_files/`
```bash
download_test.sh
```
## 2. Create input parameters file.
The following command will generate a parameters file at `TEST_inputs.sh`. This file is used to submit a 16s pipeline job.
```bash
create_inputs.py \
--input_dir test_files \
--output_dir test \
--project TEST \
--fwd _1.fastq.gz \
--rev _2.fastq.gz \
--fprimer ACACTGACGACATGGTTCTACAGTGCCAGCMGCCGCGGTAA \
--rprimer TACGGTAGCAGAGACTTGGTCTGGACTACHVGGGTWTCTAAT
```

*Note: the `\`s are for visibility of code and are not required to execute the command.*

If you view [`TEST_inputs.sh`](TEST_inputs.sh), you will see the above python command (commented out) along with your input parameters.

You can view the documentation for this script with `create_inputs.py -h`

## 3. Submit job
### Local
You can run the pipeline locally in order to observe each step. This is only recommended for this tutorial since there are only two small files.
```bash
bu16s.qsub TEST_inputs.sh
```
### SCC Batch Job
Normally, you will submit as a batch job where the pipeline will run on another computer on the SCC with more processors.

```bash
qsub $SCC_BU16S_DIR/bu16s.qsub TEST_inputs.sh
```
You can monitor the progress of your job with `qstat -u <BU username>` and by viewing the output log with `less bu16s.qsub.o<JOB ID>`

Also, while not required, you can name your job, and subsequently your job logs, with `qsub -N <Job name> ...`.

Scripts for each piece of the pipeline are in the [scripts](scripts) and any piece can be run independently by providing the input parameters file as an argument, just like running the whole pipeline.

# Parameter tuning
The nuance in processing amplicon datasets is in the parameter selection. Ideally, datasets have good quality reads that overlap - sometimes this is not the case. The following tips can be useful in troubleshooting/parameter tuning.

First, create a test input directory only containing a few (2-6) samples and run the pipeline on those samples.
Check the `stdout` output from the cutadapt steps to check that primers are being trimmed (sometimes, primers are already trimmed) and then check the dada2 stats (`<OUTPUTDIR>/intermediate/dada2/stats.tsv`) for successful read filtering, denoising, merging, and chimera check.
Here are possible interpretations and actions to take based on the results in `stats.tsv`:

- Few reads passing filter: You may want to truncate reads to exclude low quality regions (`--trunclen_{f,r}`) or be more permissive by allowing a higher expected error (`--dada2_args="--p-max-ee-{f,r}`).
- Few reads merging: This could be the result of over truncation (no overlap) or too many errors in the overlapping region, in which case more truncation may be helpful.
- Many chimeric reads: The likely culprit here is untrimmed primers

One helpful tool for choosing a truncation cutoff is the [demux summarize function](https://docs.qiime2.org/2020.6/plugins/available/demux/summarize/) which generates a distribution of quality scores for each position from a subsampling of reads from your dataset. To generate this distribution:
1. With your input directory set to a directory containing all samples, run the pipeline through the cutadapt step (easiest way to do `bash $BU16s/bu16s.qsub <path/to/inputs.sh>` and then press `Ctrl+c` once `dada2` starts)
2. Then create the visualizer object:
    ```bash
    # Activate QIIME
    module purge
    module load miniconda/4.7.5
    module load qiime2/2020.2
    export LC_ALL=en_US.utf-8
    export LANG=en_US.utf-8
    conda activate $SCC_QIIME2_DIR
    # Create visualizer object
    qiime demux summarize --i-data <project>_trimmed.qza --o-visualization <project>_trimmed.qzv
    ```
3. Download this to your local machine (ex. in a local terminal `scp bu_username@scc1.bu.edu:/path/to/<project>_trimmed.qzv .`)
4. Drag and drop to [https://view.qiime2.org/](https://view.qiime2.org/)
5. Click on "Interactive Quality Plot" to see where quality dramatically dips
