# Project directory
ADV_PATH="/home/thanasis-linux"


PY_PATH="${ADV_PATH}/ex4-helpcode/32_edp.py"


BN_PATH="${ADV_PATH}/ex4-helpcode/power_32"

PN_PATH="${ADV_PATH}/ex4-helpcode/energy_32"



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

TMP_PATH="$BN_PATH/$grain"
BNC_PATH=""

for topology in "${Topologies[@]}"; do
    for synch in "${Syncs[@]}"; do
        BNC_PATH="${BNC_PATH} $TMP_PATH/${synch}_${topology}"
    done
done

$PY_PATH 1 $BNC_PATH
