#!/usr/bin/env python3
import re
import sys
import linecache
from pathlib import Path

regex = re.compile('#?(.*)\s?=\s?(.*)')
data = ''

try:
    fpath = str(sys.argv[1])
    if not Path(fpath).is_file():
        raise Exception("file path is invalid or not a file")
except:
    print("Error: file not provided or invalid file.")
    sys.exit(1)

try:
  with open(fpath, 'r') as fh:
    lines = fh.readlines()
    for line in lines:
        if re.search('^\n', line):
            data += line
        elif regex.search(line):
            match = regex.search(line)

            comment = ''
            if re.search('^#.*', line):
                comment = '#'

            data += (comment + match.group(1) + "={{ getenv(\"" + match.group(1).replace('.', '_').upper() + "\", \"" + match.group(2) + "\") }} " + "\n")
        elif re.search('^#.*', line):
            data += line
        else:
            pass

  with open(fpath + '.new', 'w') as fh:
    fh.write(data)
except Exception as err:
    exc_type, exc_obj, tb = sys.exc_info()
    f = tb.tb_frame
    lineno = tb.tb_lineno
    filename = f.f_code.co_filename
    linecache.checkcache(filename)
    line = linecache.getline(filename, lineno, f.f_globals)
    print('EXCEPTION IN ({}, LINE {} "{}"): {}'.format(filename, lineno, line.strip(), exc_obj))

