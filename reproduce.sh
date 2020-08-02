#!/bin/bash
SETTING=${1:-LambdaSAEHD_rep_mini}
TARGET_ITER=${2:-50}
TRAINING_DATA_SRC_DIR=${3:-~/_src/Dr_Fauci/WholeFace/_Custom_Batches/aligned}
TRAINING_DATA_DST_DIR=${4:-~/_src/Trey_TrainingData/WholeFace/TreyEgg_WF}
AMP=${5:-off}
BS_PER_GPU=${6:-1}
IDX=${7:-0,1}
API=${8:-dfl}
OPT=${9:-adam}
LR=${10:-0.0001}
DECAY_STEP=${11:-1000}
OUTPUT_PATH=${12:-reproduce/tmp}
MONITOR_INTERVAL=0.1

MODEL_PATH="${OUTPUT_PATH}/model"
LOG_PATH="${OUTPUT_PATH}/log.txt"
MONITOR_PATH="${OUTPUT_PATH}/monitor.csv"

MODEL=(${SETTING//_/ })

command_para="train \
--training-data-src-dir=${TRAINING_DATA_SRC_DIR} \
--training-data-dst-dir=${TRAINING_DATA_DST_DIR} \
--model-dir ${MODEL_PATH} \
--no-preview \
--model ${MODEL} \
--force-gpu-idxs ${IDX} \
--force-model-name model \
--config-file benchmark/reproduce/${SETTING}.yaml \
--target-iter ${TARGET_ITER} \
--bs-per-gpu ${BS_PER_GPU} \
--api ${API} \
--opt ${OPT} \
--lr ${LR} \
--decay-step ${DECAY_STEP}"

if [ "$AMP" == "on" ]; then
    command_para="${command_para} --use-amp"
fi

echo $command_para

flag_monitor=true
python main.py ${command_para} 2>&1 | tee $LOG_PATH &
while $flag_monitor;
do
    sleep $MONITOR_INTERVAL 
    last_line="$(tail -1 ${LOG_PATH})"
    if [[ $last_line == *"Done."* ]]; then
        flag_monitor=false
    else
        status="$(nvidia-smi -i $IDX --query-gpu=temperature.gpu,utilization.gpu,memory.used --format=csv)"
        echo "${status}" >> $MONITOR_PATH
    fi
done
echo "${LOG_NAME} is done" 


