#!/usr/bin/env python

import sys, os
import itertools, operator
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

def get_params_from_basename(basename):
	tokens = basename.split('.')
	bench = tokens[0].split('/')[0]
	input_size = 'ref'
	dw = int(tokens[1].split('-')[0].split('_')[1])
	ws = int(tokens[1].split('-')[1].split('_')[1])
	return (bench, input_size, dw, ws)

def get_joule_from_output_file(output_file):
	joule = -999
	fp = open(output_file, "r")
	line = fp.readline()
	while line:
		if "total" in line:
			joule = float(line.split()[3])
		line = fp.readline()

	fp.close()
	return joule

def get_instructions_from_output_file(output_file):
	fp = open(output_file, "r")
	line = fp.readline()
	while line:
		if "Instructions" in line:
			ipc = int(line.split()[2])
		line = fp.readline()

	fp.close()
	return ipc

def tuples_by_dispatch_width(tuples):
	ret = []
	tuples_sorted = sorted(tuples, key=operator.itemgetter(0))
	for key,group in itertools.groupby(tuples_sorted,operator.itemgetter(0)):
		ret.append((key, zip(*map(lambda x: x[1:], list(group)))))
	# print(ret)
	return ret

global_ws = [16,32,64,96,128,192,256,384]

if len(sys.argv) < 2:
	print "usage:", sys.argv[0], "<output_directories>"
	sys.exit(1)

results_tuples = []
inst=[]
for dirname in sys.argv[2:]:
	if dirname.endswith("/"):
		dirname = dirname[0:-1]
	basename = os.path.basename(dirname)
	output_file = dirname + "/sim.out"
	power_file = dirname + "/power.total.out"

	(bench, input_size, dispatch_width, window_size) = get_params_from_basename(basename)
	# uncomment the following line if u wish to throw away some non-necessary benchmarks
	# if(dispatch_width > window_size): continue  
	joule = get_joule_from_output_file(power_file)
	inst.append(get_instructions_from_output_file(output_file))
	results_tuples.append((dispatch_width, window_size, joule))
print("inst:",inst)
inst = np.mean(inst) / 10**7
if inst>100 : 
	inst = 100

markers = ['.', 'o', 'v', '*', 'D']
fig = plt.figure()
plt.grid(True)
ax = plt.subplot(111)
ax.set_xlabel("$Window Size$")
ax.set_ylabel("$Energy (Joule)$")

#i = 0
tuples_by_dw = tuples_by_dispatch_width(results_tuples)
for tuple,i in zip(tuples_by_dw,range(len(tuples_by_dw))):
	##############  TESTING  #######################
	# print("tuple[0] = %s"%(tuple[0]))
	# print("tuple[1][0] =%s"%(tuple[1][0]))
	################################################
	dw = tuple[0]
	ws_axis = tuple[1][0]
	ipc_axis = tuple[1][1]
	x_ticks = np.arange(0, len(global_ws))
	x_labels = map(str, global_ws)
	ax.xaxis.set_ticks(x_ticks)
	ax.xaxis.set_ticklabels(x_labels)
	ax.set_title(str(bench)+"/total instructions:"+str(inst)+"%")
	print x_ticks
	print ipc_axis
	ax.plot(x_ticks, ipc_axis, label="DW_"+str(dw), marker=markers[i%len(markers)])
	#i = i + 1


lgd = ax.legend(ncol=len(tuples_by_dw), bbox_to_anchor=(0.9, -0.1), prop={'size':8})
plt.savefig(sys.argv[1]+bench+'-'+input_size+'.power.png', bbox_extra_artists=(lgd,), bbox_inches='tight')
plt.clf
ax.clear()
