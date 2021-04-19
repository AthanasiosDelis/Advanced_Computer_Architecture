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

def get_energy_from_output_file(output_file):
    energy = -999
    fp = open(output_file, "r")
    line = fp.readline()
    while line:
        if "total" in line:
            energy = line.split("W", 1)[1]
            energy = energy.split("J", 1)[0]
            if "k" in energy:
                energy = energy.split("k", 1)[0]
                energy = float(energy) * pow(10, 3)
            else:
                energy = float(energy)
        line = fp.readline()

    fp.close()
    return energy

def tuples_by_first(tuples):
    ret = []
    tuples_sorted = sorted(tuples, key=operator.itemgetter(0))
    for key,group in itertools.groupby(tuples_sorted,operator.itemgetter(0)):
        ret.append((key, zip(*map(lambda x: x[1:], list(group)))))
    return ret

def get_runtime(sync, topology):
    path = "/home/thanasis-linux/ex4-helpcode/output_32/" + sync + "_" + str(topology) + "/sim.out"
    fp = open(path, "r")
    line = fp.readline()
    while line:
        if "Time (ns)" in line:
            rtm = line.split("|")[1]
        line = fp.readline()
    fp.close()
    return int(rtm)

global_sc = ["TAS_CAS", "TAS_TS", "TTAS_CAS", "TTAS_TS", "MUTEX"]
global_tp = [1, 2, 3]

if len(sys.argv) < 3:
    print "usage:", sys.argv[0], "<grain>", "<output_directories>"
    sys.exit(1)

results_tuples = []
grain = int(sys.argv[1])

for dirname in sys.argv[2:]:
    if dirname.endswith("/"):
        dirname = dirname[0:-1]
    basename = os.path.basename(dirname)
    output_file = dirname + ".out"

    (sync, input_size, topology) = get_params_from_basename(basename)
    energy = get_energy_from_output_file(output_file)
    runtime = get_runtime(sync, topology)
    edp = (energy * runtime) / (pow(10, 9))
    results_tuples.append((sync, topology, edp))


markers = ['.', 'o', 'v', '*', 'D']
fig = plt.figure()
plt.grid(True)
ax = plt.subplot(111)
ax.set_xlabel("$Topology$")
ax.set_ylabel("$EDP (J * sec)$")

i = 0
tuples_by_1st = tuples_by_first(results_tuples)
for tuple in tuples_by_1st:
    sc = tuple[0]
    tp_axis = tuple[1][0]
    edp_axis = tuple[1][1]
    x_ticks = np.arange(0, len(global_tp))
    x_labels = map(str, global_tp)
    ax.xaxis.set_ticks(x_ticks)
    ax.xaxis.set_ticklabels(x_labels)

    print x_ticks
    print edp_axis
    ax.plot(x_ticks, edp_axis, label=sc, marker=markers[i%len(markers)])
    i = i + 1

lgd = ax.legend(ncol=len(tuples_by_1st), bbox_to_anchor=(0.9, -0.1), prop={'size':8})
plt.savefig("32_" + str(topology) + '.edp.png', bbox_extra_artists=(lgd,), bbox_inches='tight')
