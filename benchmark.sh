#!/bin/bash
GPU_TYPE=TitanRTX
CONFIG_NAME=liae_128_128_64_64
GPU_IDXS=0,1

TRAINING_DATA_SRC_DIR=~/data/dfl/Gordon_face
TRAINING_DATA_DST_DIR=~/data/dfl/Snowden_face
MODEL=LambdaSAEHD
MODEL_NAME=lambda-gordon-snowden

GPUS=(${GPU_IDXS//,/ })
NUM_GPU=${#GPUS[@]}
LOG_NAME=benchmark/log/${CONFIG_NAME}_${NUM_GPU}x${GPU_TYPE}.txt

rm -rf output && \
python main.py train \
--training-data-src-dir=$TRAINING_DATA_SRC_DIR \
--training-data-dst-dir=$TRAINING_DATA_DST_DIR \
--model-dir output \
--model $MODEL \
--force-gpu-idxs $GPU_IDXS \
--no-preview \
--force-model-name $MODEL_NAME \
--config-file benchmark/config/${CONFIG_NAME}.yaml  2>&1 | tee $LOG_NAME


GPU_IDXS=0
GPUS=(${GPU_IDXS//,/ })
NUM_GPU=${#GPUS[@]}
LOG_NAME=benchmark/log/${CONFIG_NAME}_${NUM_GPU}x${GPU_TYPE}.txt

rm -rf output && \
python main.py train \
--training-data-src-dir=$TRAINING_DATA_SRC_DIR \
--training-data-dst-dir=$TRAINING_DATA_DST_DIR \
--model-dir output \
--model $MODEL \
--force-gpu-idxs $GPU_IDXS \
--no-preview \
--force-model-name $MODEL_NAME \
--config-file benchmark/config/${CONFIG_NAME}.yaml  2>&1 | tee $LOG_NAME