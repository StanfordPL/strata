"""
Configuration information
"""
import math
import os
from matplotlib import rc
import matplotlib as mpl
import matplotlib.pyplot as plt

here = os.path.dirname(os.path.realpath(__file__))
data_path = here + "/../../bin"
output = data_path

def get_fig_size(width = None, height = None, columns = 2):
  if width is None:
    width = 12 # base width
    if columns > 1:
      width /= columns

  if height is None:
    golden_mean = (math.sqrt(5)-1.0)/2.0    # Aesthetic ratio
    height = width*golden_mean # height in inches
  return [width, height]

def colors(): return ['royalblue', 'teal']

def setup(fig_size = get_fig_size()):
  mpl.rcParams['figure.figsize'] = fig_size
  rc('font', **{'family': 'serif', 'serif': ['Computer Modern']})
  rc('text', usetex=True)

  plt.style.use(here + '/style.mplstyle')
