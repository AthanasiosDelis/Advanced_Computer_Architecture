# Project directory
ADV_PATH="/home/thanasis-linux"

# Python mcPAT path
PY_PATH="${ADV_PATH}/sniper-7.3/tools/advcomparch_mcpat.py"

# Benchmark directory
BN_PATH="${ADV_PATH}/ex4-helpcode/output"

# Output directory
PN_PATH="${ADV_PATH}/ex4-helpcode/power"

# ------------------------------------------------

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

    for synch in "${Syncs[@]}"; do

        for nthread in "${Nthreads[@]}"; do

            # Benchmark input
            BNC_PATH="${BN_PATH}/${grain}/${synch}_$nthread"

            # PNG & Output naming scheme
            PNG_PATH="${PN_PATH}/${grain}/${synch}_${nthread}"

            # Log file
            OUT_FILE="${PN_PATH}/${grain}/${synch}_${nthread}.out"

            # Create output dir
            mkdir -p ${PN_PATH}/${grain}

            # Execute the script and create the McPAT analysis
            ${PY_PATH} -d ${BNC_PATH} -t total -o ${PNG_PATH} > ${OUT_FILE}

        done

    done

done
