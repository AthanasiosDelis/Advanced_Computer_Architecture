ADV_PATH="/home/thanasis-linux"

# Python mcPAT path
PY_PATH="${ADV_PATH}/ex4-helpcode/314.py"

BN_PATH="${ADV_PATH}/ex4-helpcode/output_314"

# ------------------------------------------------

# Grains array
declare -a Grains=(
        "1"
        "10"
        "100"
)

for grain in "${Grains[@]}"; do

    # Execute
    $PY_PATH $grain 314.log
done
