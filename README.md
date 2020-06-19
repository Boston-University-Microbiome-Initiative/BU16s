# BU16s
16s pipeline that utilizes Boston University's SCC

# Set up
There is no installation. The code exists in the SCC.

Enter the following to setup a variable to the BU16s code base - you only need to do this once.
```bash
echo "export BU16s=/projectnb/talbot-lab-data/msilver/BU16s" >> ~/.bashrc
source ~/.bashrc
```

# Tutorial
1. Download test data (two small FASTQ files) to `test_files`
```bash
bash $BU16s/download_test.sh
```
2. Create input parameters file. This command will create one at `TEST_inputs.sh`
```bash
python $BU16s/create_inputs.py \
--input_dir test_files \
--output_dir test \
--project TEST \
--fwd _1.fastq.gz \
--rev _2.fastq.gz
```

If you view `TEST_inputs.sh`, you will see the above python command (commented out) along with your input parameters.

3. Submit job

You can run the pipeline locally in order to observe each step
This is only recommended for this tutorial since there are only two small files
```bash
bash $BU16s/bu16s.qsub TEST_inputs.sh
```

Normally, you will submit as a batch job where the pipeline will run on another computer on the SCC with more processors.

```bash
qsub $BU16s/bu16s.qsub -P <BU PROJECT NAME> TEST_inputs.sh
```
You can monitor the progress of your job with `qstat -u <BU username>` and by viewing the output log with `less bu16s.qsub.o<JOB ID>`