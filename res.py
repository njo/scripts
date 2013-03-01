#! /usr/bin/python

"""
Prints the location and resolution of the file
specified by invocation argument or stdin
"""

import Image
import sys, os

def printFileSize(f):
  if not os.path.exists(f):
    print "no file:", f
  else:
    im = Image.open(f)
    print f, im.size

if len(sys.argv) > 1:
  for f in sys.argv[1:]:
    printFileSize(f)
else:
  for l in sys.stdin:
    printFileSize(l.strip())

