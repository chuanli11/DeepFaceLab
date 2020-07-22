#!/bin/bash
SETTING=${1:-benchmark/config/config_all}
TARGET_ITER=${2:-50}
TRAINING_DATA_SRC_DIR=${3:-~/_src/Dr_Fauci/WholeFace/_Custom_Batches/aligned}
TRAINING_DATA_DST_DIR=${4:-~/_src/Trey_TrainingData/WholeFace/TreyEgg_WF}
PRECISION=${5:-float32}
AMP=${6:-off}
BS_PER_GPU=${7:-1}
LOG_DIR=${8:-log_20200715}


GPU_NAME="$(nvidia-smi -i 0 --query-gpu=gpu_name --format=csv,noheader | sed 's/ //g' 2>/dev/null || echo PLACEHOLDER )"
MONITOR_INTERVAL=2

. ${SETTING}".sh"

mkdir -p benchmark/log

for idx in $GPU_IDXS; do
    for config in $CONFIGS; do
        MODEL=(${config//_/ })
        MODEL_NAME="benchmark"
        GPUS=(${idx//,/ })
        NUM_GPU=${#GPUS[@]}

        if [ "$PRECISION" == "float16" ]; then
            LOG_NAME=benchmark/${LOG_DIR}/${config}_${NUM_GPU}x${GPU_NAME}_bs${BS_PER_GPU}_fp16
        else
            LOG_NAME=benchmark/${LOG_DIR}/${config}_${NUM_GPU}x${GPU_NAME}_bs${BS_PER_GPU}_fp32
        fi

        MODEL_DIR=output/$(echo "$LOG_NAME" | cut -f 1 -d '.')
        
        if [ "$AMP" == "on" ]; then
            MODEL_DIR=${MODEL_DIR}_amp
        fi

        command_para="train \
        --training-data-src-dir=${TRAINING_DATA_SRC_DIR} \
        --training-data-dst-dir=${TRAINING_DATA_DST_DIR} \
        --model-dir ${MODEL_DIR} \
        --model ${MODEL} \
        --no-preview \
        --force-gpu-idxs ${idx} \
        --force-model-name ${MODEL_NAME} \
        --config-file benchmark/config/${config}.yaml \
        --target-iter ${TARGET_ITER} \
        --precision ${PRECISION} \
        --bs-per-gpu ${BS_PER_GPU}"

        if [ "$AMP" == "on" ]; then
            command_para="${command_para} --use-amp"
            LOG_NAME="${LOG_NAME}_amp"
        fi

        MEM_NAME=${LOG_NAME}_mem
        
        echo $MEM_NAME        
        flag_monitor=true

        rm -rf $MODEL_DIR && rm -f ${MEM_NAME}".csv" && \
        python main.py ${command_para} 2>&1 | tee $LOG_NAME".txt" &
        while $flag_monitor;
        do
            sleep $MONITOR_INTERVAL 
            last_line="$(tail -1 ${LOG_NAME}".txt")"
            if [[ $last_line == *"Done."* ]]; then
                flag_monitor=false
            else
                status="$(nvidia-smi -i $idx --query-gpu=temperature.gpu,utilization.gpu,memory.used --format=csv)"
                echo "${status}" >> ${MEM_NAME}".csv"
            fi
        done
        echo "${LOG_NAME} is done" 
	rm -rf $MODEL_DIR
    done
done
