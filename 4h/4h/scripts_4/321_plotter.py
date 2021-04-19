#!/usr/bin/env python

import sys, os
import itertools, operator
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

def get_params_from_basename(basename):
    tokens = basename.split('_')
    sync = tokens[0]
    input_size = 'ref'
    if sync == "MUTEX":
        topology = int(tokens[1])
    else:
        sync = sync + "_" + tokens[1]
        topology = int(tokens[2])
    return (sync, input_size, topology)

def get_cycles_from_output_file(output_file):
    cycles = -999
    fp = open(output_file, "r")
    line = fp.readline()
    while line:
        if "Cycles" in line:
            cycles = int(line.split()[2])
            print(cycles)
        line = fp.readline()

    fp.close()
    return cycles

def tuples_by_first(tuples):
    ret = []
    tuples_sorted = sorted(tuples, key=operator.itemgetter(0))
    for key,group in itertools.groupby(tuples_sorted,operator.itemgetter(0)):
        ret.append((key, zip(*map(lambda x: x[1:], list(group)))))
    return ret


global_sc = ["TAS_CAS", "TAS_TS", "TTAS_CAS", "TTAS_TS", "MUTEX"]
global_tp = [1, 2, 3]

if len(sys.argv) < 3:
    print "usage:", sys.argv[0], "Grain" "<output_directories>"
    sys.exit(1)

results_tuples = []
grain = int(sys.argv[1])

for dirname in sys.argv[2:]:
    if dirname.endswith("/"):
        dirname = dirname[0:-1]
    basename = os.path.basename(dirname)
    output_file = dirname + "/sim.out"

    (sync, input_size, topology) = get_params_from_basename(basename)
    cycles = get_cycles_from_output_file(output_file)
    results_tuples.append((sync, topology, cycles))


markers = ['.', 'o', 'v', '*', 'D']
fig = plt.figure()
plt.grid(True)
ax = plt.subplot(111)
ax.set_xlabel("$Topology$")
ax.set_ylabel("$Cycles$")

i = 0
tuples_by_1st = tuples_by_first(results_tuples)
for tuple in tuples_by_1st:
    sc = tuple[0]
    tp_axis = tuple[1][0]
    cycles_axis = tuple[1][1]
    x_ticks = np.arange(0, len(global_tp))
    x_labels = map(str, global_tp)
    ax.xaxis.set_ticks(x_ticks)
    ax.xaxis.set_ticklabels(x_labels)

    print x_ticks
    print cycles_axis
    ax.plot(x_ticks, cycles_axis, label=str(sc), marker=markers[i%len(markers)])
    i = i + 1

lgd = ax.legend(ncol=len(tuples_by_1st), bbox_to_anchor=(0.9, -0.1), prop={'size':8})
plt.savefig("321_" + str(topology) + '.cycles.png', bbox_extra_artists=(lgd,), bbox_inches='tight')
