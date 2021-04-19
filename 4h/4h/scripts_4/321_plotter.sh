ADV_PATH="/home/thanasis-linux"
PY_PATH="${ADV_PATH}/ex4-helpcode/321_plotter.py"
BN_PATH="${ADV_PATH}/ex4-helpcode/output_32"

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

TMP_PATH="$BN_PATH"
BNC_PATH=""
for topology in "${Topologies[@]}"; do
    # Set benchmark

    for synch in "${Syncs[@]}"; do
        # Create string of benchmarks
        BNC_PATH="$BNC_PATH $TMP_PATH/${synch}_${topology}"
    done

done

$PY_PATH 1 $BNC_PATH
