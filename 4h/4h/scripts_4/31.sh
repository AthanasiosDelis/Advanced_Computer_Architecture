#!/bin/bash


ACA_PATH="/home/thanasis-linux" &> /dev/null

HLP_PATH="${ACA_PATH}/ex4-helpcode" &> /dev/null # CSLab Helper code & pintool
SNP_PATH="${ACA_PATH}/sniper-7.3" &> /dev/null   # Sniper folder

LCK_PATH="${ACA_PATH}/locks"
OUT_PATH="${HLP_PATH}/output"


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
        "4"
        "8"
        "16"
)

declare -a Grains=(
        "1"
        "10"
        "100"
)

for Sync in "${Syncs[@]}"; do

    for Nthread in "${Nthreads[@]}"; do

        for Grain in "${Grains[@]}"; do

            # Set Lthreads
            if [[ "$Nthread" == "1" ]]; then
                L2thread="1"
                L3thread="1"
            elif [[ "$Nthread" == "2" ]]; then
                L2thread="2"
                L3thread="2"
            elif [[ "$Nthread" == "4" ]]; then
                L2thread="4"
                L3thread="4"
            elif [[ "$Nthread" == "8" ]]; then
                L2thread="4"
                L3thread="8"
            elif [[ "$Nthread" == "16" ]]; then
                L2thread="1"
                L3thread="8"
            fi


            OUTDIR="${OUT_PATH}/${Grain}/${Sync}_${Nthread}"

            ${SNP_PATH}/run-sniper -c ${HLP_PATH}/ask4.cfg -n ${Nthread} --roi -g \
            perf_model/l2_cache/shared_cores=${L2thread} -g \
            perf_model/l3_cache/shared_cores=${L3thread} \
            ${LCK_PATH}/${Sync}/locks ${Nthread} 1000 ${Grain}

            # Copy results to specified folder only if they were actually generated
            if [[ -f "$HLP_PATH/sim.out" ]]; then
                mkdir -p "$OUTDIR"
                mv app* $OUTDIR/
                mv sim* $OUTDIR/
            else
                rm app*
                rm sim*
            fi

        done

    done

done
