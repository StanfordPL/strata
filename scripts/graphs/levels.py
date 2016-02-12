#!/usr/bin/env python
"""

Plot distribution of levels

"""
import csv
import config
import matplotlib.pyplot as plt

config.setup()

# load data
data = []
with open(config.data_path + '/levels.csv', 'rb') as csvfile:
  spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
  for row in spamreader:
    data.append(int(row[0]))

# make data into histrogram
total = len(data)
xs = range(max(data) + 1)
ys = map(lambda x: float(len(filter(lambda i: i == x, data)))/total, xs)

width = 0.7
fig, ax = plt.subplots()
rects = ax.bar([i+(1.-width)/2. for i in xs], ys, width, color=config.colors()[0])

ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

plt.gca().set_xlim([min(data),max(data) + 1])

c = 0
for rect in rects:
  height = rect.get_height()
  ax.text(rect.get_x() + rect.get_width()/2., height, '%d' % int(round(height*total)),
          ha='center', va='bottom', size=11)
  ax.text(rect.get_x() + rect.get_width()/2., -0.004, str(c),
          ha='center', va='top', size=14)
  c += 1

rects[0].set_facecolor(config.colors()[1])

plt.xlabel('Stratum', labelpad=25)
plt.ylabel('Fraction of formulas')
plt.xticks([])

plt.subplots_adjust(left=0.13, bottom=0.18)
plt.savefig(config.output + '/levels.pdf')
