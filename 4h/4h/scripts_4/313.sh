
ADV_PATH="/home/thanasis-linux"
PY_PATH="${ADV_PATH}/ex4-helpcode/313.py"
BN_PATH="${ADV_PATH}/ex4-helpcode/power"
PN_PATH="${ADV_PATH}/ex4-helpcode/energy"

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

# Grains array
declare -a Grains=(
        "1"
        "10"
        "100"
)

for grain in "${Grains[@]}"; do

    TMP_PATH="$BN_PATH/$grain"
    BNC_PATH=""

    for synch in "${Syncs[@]}"; do
        for nthread in "${Nthreads[@]}"; do
        # Generate benchmark path
            BNC_PATH="${BNC_PATH} $TMP_PATH/${synch}_$nthread"
        done
    done

    # Execute the python script
    $PY_PATH $grain $BNC_PATH
done
