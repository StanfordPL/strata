#!/usr/bin/env python
"""

Plot the progress over time

"""
import csv
import config
import matplotlib.pyplot as plt

config.setup()

# load data
x = []
y1 = []
y2 = []
with open(config.data_path + '/progress.csv', 'rb') as csvfile:
  spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
  for row in spamreader:
    x.append(float(row[0]))
    y1.append(int(float(row[1])))
    y2.append(int(float(row[2])))

l1 = plt.plot(x, y1, '-', linewidth=1, label='Progress')
l2 = plt.plot(x, y2, '--', linewidth=1, label='Progress without stratification')

plt.legend(loc='lower right')

plt.gca().set_xlim([min(x),max(x)])
plt.gca().set_ylim([0, 750])

plt.xlabel('Wall-clock time elapsed [hours]')
plt.ylabel('Number of formulas learned')

plt.subplots_adjust(left=0.13, bottom=0.18)
plt.savefig(config.output + '/progress.pdf')
