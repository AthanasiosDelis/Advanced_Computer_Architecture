#!/bin/bash

## Example of usage: ./run_sniper.sh gcc
## Modify the following paths appropriately
## CAUTION: use only absolute paths below!!!
MCPAT_EXE=/home/thanasis-linux/sniper-7.3/tools/advcomparch_mcpat.py

SNIPER_STATS=total
INPUT_DIR_BASE="/home/thanasis-linux/outputs"
OUTPUT_DIR_BASE=/home/thanasis-linux/mcpat
FILE=power
for BENCH in $@; do
	benchInDir=${INPUT_DIR_BASE}/$BENCH
	benchOutDir=${OUTPUT_DIR_BASE}/$BENCH
	mkdir -p $benchOutDir

for dw in 1 2 4 8 16 32; do
for ws in 16 32 64 96 128 192 256 384; do
	Dir=$(printf "%s.DW_%02d-WS_%03d.out" $BENCH $dw $ws)
	inDir="${benchInDir}/${Dir}"
	oDir=$(printf "%s.DW_%02d-WS_%03d" $BENCH $dw $ws)

	outDir=${benchOutDir}/${oDir}
	mkdir -p $outDir
	outDir="${outDir}/power >${inDir}/power.total.out" 

	
	sniper_cmd="${MCPAT_EXE} -d ${inDir} -t ${SNIPER_STATS}  -o ${outDir} --no-graph"
	echo \"$sniper_cmd\"
	/bin/bash -c "$sniper_cmd"
done
done

done
