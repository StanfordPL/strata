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
with open(config.data_path + '/strata-simplication-increase.csv', 'rb') as csvfile:
  spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
  for row in spamreader:
    data.append(float(row[0]))

low = 2.
high = 2500.

print high
print max(data)
print low
print min(data)
assert(min(data) > 1/2)
assert(max(data) < high)

nbins = 40
fig, ax = plt.subplots()
ax.set_xscale('log')
rects = ax.hist(data, bins=10 ** np.linspace(math.log10(1./low), math.log10(high), 40))
plt.gca().set_xlim([1./low,high])
plt.xticks([ 1, 10, 100 ,1000], ["equal", "10x smaller", "100x smaller", "1000x smaller"], rotation=0)
for tick in ax.xaxis.get_major_ticks():
  tick.label.set_fontsize(12) 

# c = 0
# for rect in rects:
#   height = rect.get_height()
#   ax.text(rect.get_x() + rect.get_width()/2., height, '%d' % int(height*total),
#           ha='center', va='bottom', size=10)
#   ax.text(rect.get_x() + rect.get_width()/2., -0.004, str(c),
#           ha='center', va='top', size=14)
#   c += 1

plt.xlabel('Relative size decrease simplified formulas')
plt.ylabel('Number of formulas')

plt.subplots_adjust(left=0.13, bottom=0.18)
plt.savefig(config.output + '/size2.pdf')
