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
y = []
with open(config.data_path + '/progress.csv', 'rb') as csvfile:
  spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
  for row in spamreader:
    x.append(float(row[0]))
    y.append(int(float(row[1])))

fig, ax = plt.subplots()
rects = ax.plot(x, y, '-', linewidth=1)

plt.gca().set_xlim([min(x),max(x)])
plt.gca().set_ylim([0, 750])

plt.xlabel('Wall-clock time elapsed [hours]')
plt.ylabel('Number of formulas learned')

plt.subplots_adjust(left=0.13, bottom=0.18)
plt.savefig(config.output + '/progress.pdf')
