#!/usr/bin/env python
"""

Plot distribution of size increases

"""
import csv
import config
import matplotlib.pyplot as plt
import numpy as np
import math

config.setup()

# load data
data = []
with open(config.data_path + '/strata-increase.csv', 'rb') as csvfile:
  spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
  for row in spamreader:
    data.append(float(row[0]))

lim = 20.0
# print lim
# print max(data)
# print 1/lim
# print min(data)
assert(lim > max(data))
assert(1/lim < min(data))

nbins = 40
fig, ax = plt.subplots()
ax.set_xscale('log')
rects = ax.hist(data, bins=10 ** np.linspace(math.log10(1/lim), math.log10(lim), 40))
plt.gca().set_xlim([1/lim,lim])
plt.xticks([ 1./9., 1./3., 1, 3, 9], ["9x smaller", "3x smaller", "equal", "3x larger", "9x larger"], rotation=0)
for tick in ax.xaxis.get_major_ticks():
  tick.label.set_fontsize(11) 

# c = 0
# for rect in rects:
#   height = rect.get_height()
#   ax.text(rect.get_x() + rect.get_width()/2., height, '%d' % int(height*total),
#           ha='center', va='bottom', size=10)
#   ax.text(rect.get_x() + rect.get_width()/2., -0.004, str(c),
#           ha='center', va='top', size=14)
#   c += 1

plt.xlabel('Relative size increase for \\textsc{Strata} formulas')
plt.ylabel('Number of formulas')

plt.subplots_adjust(left=0.13, bottom=0.18)
plt.savefig(config.output + '/size.pdf')
