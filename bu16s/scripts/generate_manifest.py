"""
Generate QIIME2 Manifest File

https://docs.qiime2.org/2020.2/tutorials/importing/#fastq-manifest-formats

Author: msilver4@bu.edu
"""
from argparse import ArgumentParser, RawTextHelpFormatter
from glob import glob
import os
import pandas as pd

def gen_manifest(input_dir, fwd_fmt, rev_fmt):
    """
    Generate manifest
    ** Will only take paired files where BOTH pairs are present
    :param input_dir: Directory housing sequencing files
    :param fwd_fmt: File extension of forward reads
    :param rev_fmt: File extension of reverse reads
    :return: Manifest table
    """
    """Gather file paths"""
    all_files = glob(os.path.join(input_dir, '*'))
    all_fwd = [os.path.abspath(f) for f in all_files if f.endswith(fwd_fmt)]

    """Create manifest"""
    # paired = sample-id | forward-absolute-filepath | reverse-absolute-filepath
    # single = sample-id | absolute-path

    col_order = ['sample-id']

    ### Get r1
    fwd_col_name = 'forward-absolute-filepath' if rev_fmt else 'absolute-path'
    col_order.append(fwd_col_name)

    fwd_paths = pd.Series(all_fwd).rename(fwd_col_name)
    # Get r1 samples
    fwd_samples = fwd_paths.apply(lambda x: os.path.basename(x).split(fwd_fmt)[0]).rename('sample-id')
    # Create manifest
    manifest = pd.concat([fwd_paths, fwd_samples], 1)

    ### Add r2 if exists
    if rev_fmt:
        # Get rev files
        all_rev = [os.path.abspath(f) for f in all_files if f.endswith(rev_fmt)]
        # Make rev manifest
        rev_col_name = 'reverse-absolute-filepath'
        col_order.append(rev_col_name)
        rev_paths = pd.Series(all_rev).rename(rev_col_name)
        rev_samples = rev_paths.apply(lambda x: os.path.basename(x).split(rev_fmt)[0]).rename('sample-id')
        rev_manifest = pd.concat([rev_paths, rev_samples], 1)
        # Add to main manifest
        manifest = manifest.merge(rev_manifest)

    # Order columns as QIIME expects
    manifest = manifest[col_order]
    return manifest

if __name__ == '__main__':
    """Parse arguments"""
    parser = ArgumentParser(formatter_class=RawTextHelpFormatter, description=__doc__)
    parser.add_argument('-i', help='Input directory', required=True)
    parser.add_argument('-f', help='Forward sequence filename extension\n'
                                   '\t*Example: For "file1-r1.fastq.gz", -f = "-r1.fastq.gz"',
                        required=True)
    parser.add_argument('-r', help='Reverse sequence filename extension\n'
                                   '\t**KEEP BLANK FOR SINGLE-END FILES**')
    parser.add_argument('-o', help='Output directory\n'
                                   '\t*File will be saved as: {-o}/manifest\n'
                                   '\t*Keep projects in separate directories to avoid overwritting')

    args = parser.parse_args()

    """Generate manifest file"""
    # Create table
    manifest = gen_manifest(args.i, args.f, args.r)

    # Save
    if not os.path.isdir(args.o):
        os.makedirs(args.o)
    outfile = os.path.join(args.o, 'manifest')
    manifest.to_csv(outfile, '\t', index=False)