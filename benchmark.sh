#!/bin/bash
SETTING=${1:-benchmark/config/config_all}
TARGET_ITER=${2:-50}
TRAINING_DATA_SRC_DIR=${3:-~/data/dfl/Gordon_face}
TRAINING_DATA_DST_DIR=${4:-~/data/dfl/Snowden_face}
PRECISION=${5:-float32}
BS_PER_GPU=${6:-1}
LOG_DIR=${7:-log_20200715}

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
            LOG_NAME=benchmark/${LOG_DIR}/${config}_${NUM_GPU}x${GPU_NAME}_bs${BS_PER_GPU}_fp16.txt
        else
            LOG_NAME=benchmark/${LOG_DIR}/${config}_${NUM_GPU}x${GPU_NAME}_bs${BS_PER_GPU}_fp32.txt
        fi        

        rm -rf output && \
        python main.py train \
        --training-data-src-dir=$TRAINING_DATA_SRC_DIR \
        --training-data-dst-dir=$TRAINING_DATA_DST_DIR \
        --model-dir output \
        --model $MODEL \
        --force-gpu-idxs $idx \
        --no-preview \
        --force-model-name $MODEL_NAME \
        --config-file benchmark/config/${config}.yaml \
        --target-iter $TARGET_ITER  \
        --precision $PRECISION \
        --bs-per-gpu $BS_PER_GPU 2>&1 | tee $LOG_NAME
    done
done
