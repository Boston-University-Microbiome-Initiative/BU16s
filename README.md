# BU16s
16s pipeline that utilizes Boston University's SCC

# Tutorial
1. Download test data (two small FASTQ files) to `test_files`
```bash
bash download_test.sh
```
2. Create input parameters file
```bash
python create_inputs.py \
--input_dir test_files \
--output_dir test \
--project TEST \
--fwd _1.fastq.gz \
--rev _2.fastq.gz
```
3. Submit job
You can run the pipeline locally in order to observe each step
This is only recommended for this tutorial since there are only two small files
```bash
bash bu16s.qsub TEST_inputs.sh
```

Normally, you will submit as a batch job where the pipeline will run on another computer with more processors.

Once your project is correct, you can submit the batch job with `qsub`
```bash
qsub bu16s.qsub -P <BU PROJECT NAME> TEST_inputs.sh
```
You can monitor the progress of your job with `qstat -u <BU username>` and by viewing the output log with `less bu16s.qsub.o<JOB ID>`