# BU16s
16s pipeline that utilizes Boston University's SCC

# Tutorial
1. Download test data to `test_files`
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
