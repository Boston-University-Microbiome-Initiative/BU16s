"""
Generate input file for submitting to bu16s.qsub

Single end mode: Only provide parameters for forward read arguments

After input file is generated, it can be used to submit a 16s pipeline job:

qsub BU16s/bu16s.qsub path/to/your/PROJECT_inputs.sh

Author: msilver4@bu.edu
"""

from argparse import ArgumentParser, RawTextHelpFormatter
import os, sys

if __name__ == '__main__':
    parser = ArgumentParser(formatter_class=RawTextHelpFormatter, description=__doc__)
    parser.add_argument('--project', help='Project name (ex. name of dataset)', required=True)
    parser.add_argument('--input_dir', help='Full path to directory containing FASTQ files', required=True)
    parser.add_argument('--output_dir', help='Full path to desired output directory', required=True)
    parser.add_argument('--fwd', help='Forward read filename extension\n'
                                      '\tEx. sample1_1.fastq.gz\n'
                                      '\t\t--fwd _1.fastq.gz\n'
                                      '\tIf extension starts with a "-", like sample1-r1.fastq.gz\n'
                                      '\t\t --fwd="-r1.fastq.gz"', required=True)
    parser.add_argument('--rev', help='Reverse read filename extension\n'
                                      '\tLEAVE BLANK FOR SINGLE END')
    parser.add_argument('--fprimer', help='Forward primer. Default is 515F:\n'
                                          '\tGTGCCAGCMGCCGCGGTAA', default='GTGCCAGCMGCCGCGGTAA')
    parser.add_argument('--rprimer', help='Reverse primer. Default is 806R:\n'
                                          '\tGGACTACHVHHHTWTCTAAT\n'
                                          '\tInclude in single end mode to search for reverse primer in reads',
                                            default='GGACTACHVHHHTWTCTAAT')
    parser.add_argument('--trunclen_f', help='Length to truncate forward reads to for DADA2.\n'
                                           '\tDeafult is no truncation', default=0)
    parser.add_argument('--trunclen_r', help='Length to truncate reverse reads for DADA2.\n'
                                             '\tDefault is no truncation', default=0)
    parser.add_argument('--primer_end', help='Which end primer is ligated to\n'
                                             '\tOptions: 5 [default] or 3', choices=['5', '3'], default=5)
    parser.add_argument('--cutadapt_args', help='Additional arguments to pass to cutadapt\n'
                                                '\tEx. --cutadapt_args="--p-error-rate .2"', default='')
    parser.add_argument('--dada2_args', help='Additional arguments to pass to DADA2\n'
                                             '\tEx. --dada2_args="--p-trunc-q 3"', default='')
    parser.add_argument('--outpath', help='Where to save inputs parameter file\n'
                                          '\tDefault: ./<PROJECTNAME>_inputs.sh')

    args = parser.parse_args()

    """I/O"""
    indir = os.path.abspath(args.input_dir)
    if not os.path.isdir(indir):
        raise IOError('Input directory %s does not exist' % indir)
    outdir = os.path.abspath(args.output_dir)
    if not os.path.exists(outdir):
        os.makedirs(outdir)
    # Handle parameter file outpath
    if not args.outpath:
        outpath = '%s_inputs.sh' % args.project
    else:
        outpath = args.outpath
    # Directory for storing intermdidate files
    interdir = os.path.join(outdir, 'intermediate')
    # File for storing run parameters
    rundir = os.path.join(outdir, '.runparams')

    """Paired"""
    # Paired reads if --rev is provided
    paired = bool(args.rev)

    """Collect arguments"""
    param_order = ['PROJECTNAME',
                   'INPUTDIR',
                   'OUTPUTDIR',
                   'INTERMEDIATEDIR',
                   'RUNPARAMETERS',
                   'FWD_FMT',
                   'REV_FMT',
                   'FWD_PRIMER',
                   'REV_PRIMER',
                   'PRIMER_END',
                   'DADA2_TRUNC_LEN_F',
                   'DADA2_TRUNC_LEN_R',
                   'CUTADAPT_ARGS',
                   'DADA2_ARGS',
                   'PAIRED',
                   'SCRIPTSDIR',
                   'SILVA_SEQUENCES',
                   'SILVA_TAXONOMY',
                   'CONDA_ENV']

    parameters = {'PROJECTNAME': args.project,
                  'INPUTDIR': indir,
                  'OUTPUTDIR': outdir,
                  'INTERMEDIATEDIR': interdir,
                  'RUNPARAMETERS': rundir,
                  'FWD_FMT': args.fwd,
                  'REV_FMT': args.rev,
                  'FWD_PRIMER': args.fprimer,
                  'REV_PRIMER': args.rprimer,
                  'PRIMER_END': args.primer_end,
                  'DADA2_TRUNC_LEN_F': args.trunclen_f,
                  'DADA2_TRUNC_LEN_R': args.trunclen_r,
                  'CUTADAPT_ARGS': '"%s"' % args.cutadapt_args,
                  'DADA2_ARGS': '"%s"' % args.dada2_args,
                  'PAIRED' : paired}
    # Hard coded parameters
    defaults = {'SCRIPTSDIR' : '/projectnb/microbiome/BU16s/scripts',
                'SILVA_SEQUENCES' : '/projectnb/microbiome/ref_db/silva_132_99_16S.qza',
                'SILVA_TAXONOMY' : '/projectnb/microbiome/ref_db/silva_132_99_majority_taxonomy.qza',
                'CONDA_ENV' : '/projectnb/talbot-lab-data/msilver/.conda/envs/qiime2-2020.2'}
    # Add defaults to user-define
    parameters.update(defaults)

    """Create parameter file"""
    # Add command as comment
    command = '# python ' + ' '.join(sys.argv) + '\n'
    exports = '\n'.join(['export %s=%s' % (k, parameters[k]) for k in param_order]) + '\n'
    GLOBAL_LOADS = """# Load modules and inputs
module purge
module load miniconda
export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8
conda activate $CONDA_ENV"""
    output = command + exports + GLOBAL_LOADS + '\n'
    with open(outpath, 'w') as fh:
        fh.write(output)
    print('Saved input parameters file to: %s\n'
          '\tRun locally: bash $BU16s/bu16s.qsub %s \n'
          '\t\t--or--\n'
          '\tSubmit batch job: qsub -N %s $BU16s/bu16s.qsub %s' % (outpath, outpath, args.project, outpath))
