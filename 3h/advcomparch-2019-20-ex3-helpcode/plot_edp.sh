#############################################################################################
#                                       USAGE                                               #
#############################################################################################
#
# u need this script in the same folder with 'plot_ipc_original.py', 'python plot_edp.py' scripts
# u also need the ouput folder in the same location (hmmer,gcc,zeump etc).
# Then u just write ./plotter.sh bench1 bench2 etc
#   example : ./plotter.sh gcc sjeng zeusmp
#
#############################################################################################


#!/bin/bash

## Example of usage: ./run_sniper.sh gcc
## Modify the following paths appropriately
## CAUTION: use only absolute paths below!!!
PLOT_EXE=/home/thanasis-linux/advcomparch-2019-20-ex3-helpcode/plot_edp.py

INPUT_DIR_BASE="/home/thanasis-linux/outputs"
OUTPUT_DIR_BASE=/home/thanasis-linux/plots
FILE=power
for BENCH in $@; do
	inDir=""
	benchInDir=${INPUT_DIR_BASE}/$BENCH
	benchOutDir=${OUTPUT_DIR_BASE}/$BENCH
	mkdir -p $benchOutDir

for dw in 1 2 4 8 16 32; do
for ws in 16 32 64 96 128 192 256 384; do
	Dir=$(printf "%s.DW_%02d-WS_%03d.out" $BENCH $dw $ws)
	inDir="${inDir} ${benchInDir}/${Dir}/ "
	oDir=$(printf "%s.DW_%02d-WS_%03d" $BENCH $dw $ws)
done
done
	outDir=${benchOutDir}
	mkdir -p $outDir ##/${oDir}
	outDir="${outDir}/"

	
	sniper_cmd="${PLOT_EXE} ${outDir} ${inDir} "
	echo \"$sniper_cmd\"
	/bin/bash -c "$sniper_cmd"


done
