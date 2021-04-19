#!/bin/bash

ACA_PATH="/home/thanasis-linux" &> /dev/null
HLP_PATH="${ACA_PATH}/ex4-helpcode" &> /dev/null # CSLab Helper code & pintool
LCK_PATH="${ACA_PATH}/real_locks"
OUT_PATH="${HLP_PATH}/output_314"

declare -a Syncs=(
        "TAS_CAS"
        "TAS_TS"
        "TTAS_CAS"
        "TTAS_TS"
        "MUTEX"
)

declare -a Nthreads=(
        "1"
        "2"
 #       "4"
 #       "8"
 #       "16"
)

declare -a Grains=(
        "1"
        "10"
        "100"
)

for Sync in "${Syncs[@]}"; do

    for Nthread in "${Nthreads[@]}"; do

        for Grain in "${Grains[@]}"; do

            echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
            echo " Launching ${Sync}, nthreads = ${Nthread}, grain = ${Grain}"
            echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

            OUTDIR="${OUT_PATH}/${Grain}/${Sync}_${Nthread}"

            #${SNP_PATH}/run-sniper -c ${HLP_PATH}/ask4.cfg -n ${Nthread} --roi -g --
            #perf_model/l2_cache/shared_cores=${L2thread} -g --
            #perf_model/l3_cache/shared_cores=${L3thread} --
            ${LCK_PATH}/${Sync}/locks ${Nthread} 100000000 ${Grain} 
	    ##more iterrations custom, grab the time info,argv[1] >>314.log
        done

    done

done
