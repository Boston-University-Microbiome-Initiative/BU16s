"""
Generate welcome message
"""
from argparse import ArgumentParser
def center(s, l, delim='#'):
    """Center a text s at a length l"""
    start = int(l/2 - len(s)/2)
    remain = l - (start + len(s))
    return delim * start + s + delim * remain

if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('-i', help='Inputs file')

    args = parser.parse_args()

    text = """\
########## BOSTON UNIVERSITY 16S PIPELINE ###########
# CODE: https://github.com/michaelsilverstein/BU16s #
# MAINTAINERS:                                      #
# - Michael Silverstein: msilver4@bu.edu            #
"""
    width = len(text.split('\n')[0])
    text += '#' + center('PARAMETERS', width, ' ')[1:-1] + '#\n'

    # Get parameters
    params = [l.rstrip().split('export ')[1] for l in open(args.i) if l.startswith('export')]
    for p in params:
        text += '# ' + p + '\n'

    text += '#' * width

    text = ['\t\t'+line for line in text.split('\n')]

    print(text)