#!/bin/bash

ACA_PATH="/home/thanasis-linux" &> /dev/null


HLP_PATH="${ACA_PATH}/ex4-helpcode" &> /dev/null # CSLab Helper code & pintool
SNP_PATH="${ACA_PATH}/sniper-7.3" &> /dev/null   # Sniper folder


LCK_PATH="${ACA_PATH}/locks"
OUT_PATH="${HLP_PATH}/output_32"


declare -a Syncs=(
        "TAS_CAS"
        "TAS_TS"
        "TTAS_CAS"
        "TTAS_TS"
        "MUTEX"
)

declare -a Topologies=(
        "1"
        "2"
        "3"
)

for Sync in "${Syncs[@]}"; do

    for Topology in "${Topologies[@]}"; do


        if [[ "$Topology" == "1" ]]; then
            L2thread="4"
            L3thread="4"

        elif [[ "$Topology" == "2" ]]; then
            L2thread="1"
            L3thread="4"

        elif [[ "$Topology" == "3" ]]; then
            L2thread="1"
            L3thread="1"
        fi

            OUTDIR="${OUT_PATH}/${Sync}_${Topology}"

            ${SNP_PATH}/run-sniper -c ${HLP_PATH}/ask4.cfg -n 4 --roi   \
            -g perf_model/l1_icache/shared_cores=1                      \
            -g perf_model/l1_dcache/shared_cores=1                      \
            -g perf_model/l2_cache/shared_cores=${L2thread}             \
            -g perf_model/l3_cache/shared_cores=${L3thread}             \
            ${LCK_PATH}/${Sync}/locks 4 1000 1

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
