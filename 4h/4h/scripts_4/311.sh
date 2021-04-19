# Project directory
ADV_PATH="/home/thanasis-linux"

# Python script path
PY_PATH="${ADV_PATH}/ex4-helpcode/311.py"

# Benchmark directory
BN_PATH="${ADV_PATH}/ex4-helpcode/output"

# ------------------------------------------------

# Benchmark array
declare -a Syncs=(
        "TAS_CAS"
        "TAS_TS"
        "TTAS_CAS"
        "TTAS_TS"
        "MUTEX"
)

# Nthread array
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

# Loop through grains
for grain in "${Grains[@]}"; do

    # Set benchmark paths
    TMP_PATH="$BN_PATH/$grain"
    BNC_PATH=""

    for synch in "${Syncs[@]}"; do
        for nthread in "${Nthreads[@]}"; do
            # Create string with all required benchmarks
            BNC_PATH="$BNC_PATH $TMP_PATH/${synch}_$nthread" ##with asterisks bugg
        done
    done

    # Execute the python script
    $PY_PATH $grain $BNC_PATH
done
