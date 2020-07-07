# BU16s
16s pipeline that utilizes Boston University's SCC

# Set up
There is no installation. The code exists in the SCC.

Enter the following to setup a variable to the BU16s code base - you only need to do this once.
```bash
echo "export BU16s=/projectnb/talbot-lab-data/msilver/BU16s" >> ~/.bashrc
source ~/.bashrc
```

Pipeline jobs are submitted using [bu16s.qsub](bu16s.qsub) with an inputs file as argument. Input files are generated with [create_inputs.py](create_inputs.py) - use `python $BU16s/create_inputs.py -h` to view arguments.

# Tutorial
## 1. Download test data 
Run the following command to download two small FASTQ files to `test_files/`
```bash
bash $BU16s/download_test.sh
```
## 2. Create input parameters file. 
The following command will generate a parameters file at `TEST_inputs.sh`. This file is used to submit a 16s pipeline job.
```bash
python $BU16s/create_inputs.py \
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

You can view the documentation for this script with `python $BU16s/create_inputs.py -h`

## 3. Submit job
### Local
You can run the pipeline locally in order to observe each step. This is only recommended for this tutorial since there are only two small files.
```bash
bash $BU16s/bu16s.qsub TEST_inputs.sh
```
### SCC Batch Job
Normally, you will submit as a batch job where the pipeline will run on another computer on the SCC with more processors.

```bash
qsub -P <BU PROJECT NAME> $BU16s/bu16s.qsub TEST_inputs.sh
```
You can monitor the progress of your job with `qstat -u <BU username>` and by viewing the output log with `less bu16s.qsub.o<JOB ID>`

Also, while not required, you can name your job, and subsequently your job logs, with `qsub -N <Job name> ...`.
