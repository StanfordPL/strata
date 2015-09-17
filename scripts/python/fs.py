# ------------------------------------------------------------------------------
#
# Helper functionality to interact with the file system
#
# Author: Stefan Heule <sheule@cs.stanford.edu>
#
# ------------------------------------------------------------------------------

def write_file(f, s):
  """
  print a string to a file
  """
  f = open(f, 'w')
  f.write(s)
  f.close()


def log(f, s):
  """
  appends a string to a file
  """
  f = open(f, 'a')
  f.write(s)
  f.close()


def logln(f, s):
  """
  appends a line to a file
  """
  log(f, s + "\n")


def read_file(f):
  """
  Read an entire file and return the contents
  """
  with open(f) as f:
    return f.read()

def read_file_lines_stripped(f):
  """
  Read all lines of a file, and remove trailing and leading whitespace
  """
  with open(f) as f:
    return map(lambda x: x.strip(), f.readlines())