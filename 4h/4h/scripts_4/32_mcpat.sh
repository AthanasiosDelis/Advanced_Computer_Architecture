ADV_PATH="/home/thanasis-linux"

PY_PATH="${ADV_PATH}/sniper-7.3/tools/advcomparch_mcpat.py"
BN_PATH="${ADV_PATH}/ex4-helpcode/output_32"
PN_PATH="${ADV_PATH}/ex4-helpcode/power_32"
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

for synch in "${Syncs[@]}"; do

    for topology in "${Topologies[@]}"; do
        # Benchmark input
        BNC_PATH="${BN_PATH}/${synch}_${topology}"
        # PNG & Output naming scheme
        PNG_PATH="${PN_PATH}/${synch}_${topology}"
        # Log file
        OUT_FILE="${PN_PATH}/${synch}_${topology}.out"
        mkdir -p ${PN_PATH}
        ${PY_PATH} -d ${BNC_PATH} -t total -o ${PNG_PATH} > ${OUT_FILE}

    done
done
