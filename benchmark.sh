#!/bin/bash
SETTING=${1:-benchmark/config/config_all}
TARGET_ITER=${2:-50}
TRAINING_DATA_SRC_DIR=${3:-~/data/dfl/Gordon_face}
TRAINING_DATA_DST_DIR=${4:-~/data/dfl/Snowden_face}

GPU_NAME="$(nvidia-smi -i 0 --query-gpu=gpu_name --format=csv,noheader | sed 's/ //g' 2>/dev/null || echo PLACEHOLDER )"

. ${SETTING}".sh"

mkdir -p benchmark/log

for idx in $GPU_IDXS; do
    for config in $CONFIGS; do
        MODEL=(${config//_/ })
        MODEL_NAME="benchmark"
        GPUS=(${idx//,/ })
        NUM_GPU=${#GPUS[@]}
        LOG_NAME=benchmark/log/${config}_${NUM_GPU}x${GPU_NAME}.txt

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
        --target-iter $TARGET_ITER  2>&1 | tee $LOG_NAME
    done
done
