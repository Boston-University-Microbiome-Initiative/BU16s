"""
Generate input file for submitting to bu16s.qsub

Single end mode: do not provide "--rev" argument

After input file is generated, it can be used to submit a 16s pipeline job:

qsub BU16s/bu16s.qsub path/to/your/PROJECT_inputs.sh

Author: msilver4@bu.edu
"""

from argparse import ArgumentParser, RawTextHelpFormatter
import os

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
                                          '\tGGACTACHVHHHTWTCTAAT', default='GGACTACHVHHHTWTCTAAT')
    parser.add_argument('--trunclen', help='Length to truncate reads to for DADA2.\n'
                                           '\tDeafult is no truncation', default=0)
    parser.add_argument('--outpath', help='Where to save inputs parameter file\n'
                                          '\tDefault: ./<PROJECTNAME>_inputs.sh')

    args = parser.parse_args()

    """I/O"""
    indir = os.path.abspath(args.input_dir)
    if not os.path.isdir(indir):
        raise FileNotFoundError('Input directory %s does not exist' % indir)
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
                   'DADA2_TRUNC_LEN',
                   'PAIRED',
                   'SCRIPTSDIR',
                   'SILVA_SEQUENCES',
                   'SILVA_TAXONOMY']

    parameters = {'PROJECTNAME': args.project,
                  'INPUTDIR': indir,
                  'OUTPUTDIR': outdir,
                  'INTERMEDIATEDIR': interdir,
                  'RUNPARAMETERS': rundir,
                  'FWD_FMT': args.fwd,
                  'REV_FMT': args.rev,
                  'FWD_PRIMER': args.fprimer,
                  'REV_PRIMER': args.rprimer,
                  'DADA2_TRUNC_LEN': args.trunclen,
                  'PAIRED' : paired}
    # Hard coded parameters
    defaults = {'SCRIPTSDIR' : '/projectnb/talbot-lab-data/msilver/BU16s/bu16s/scripts',
                'SILVA_SEQUENCES' : '/projectnb/talbot-lab-data/msilver/ref_db/silva_132_99_16S.qza',
                'SILVA_TAXONOMY' : '/projectnb/talbot-lab-data/msilver/ref_db/silva_132_99_majority_taxonomy.qza'}
    # Add defaults to user-define
    parameters.update(defaults)

    """Create parameter file"""
    exports = '\n'.join(['export %s=%s' % (k, parameters[k]) for k in param_order])
    with open(outpath, 'w') as fh:
        fh.write(exports)
    print('Saved input parameters file to: %s' % outpath)