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

        rm -rf $MODEL_DIR && \
        python main.py ${command_para} 2>&1 | tee $LOG_NAME".txt"

        #rm -rf $MODEL_DIR && \
        #python main.py train \
        #--training-data-src-dir=$TRAINING_DATA_SRC_DIR \
        #--training-data-dst-dir=$TRAINING_DATA_DST_DIR \
        #--model-dir $MODEL_DIR \
        #--model $MODEL \
        #--no-preview \
        #--force-gpu-idxs $idx \
        #--force-model-name $MODEL_NAME \
        #--config-file benchmark/config/${config}.yaml \
        #--target-iter $TARGET_ITER  \
        #--precision $PRECISION \
        #--bs-per-gpu $BS_PER_GPU 2>&1 | tee $LOG_NAME
    done
done
