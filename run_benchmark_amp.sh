#!/bin/bash

BS_PER_GPU_FP32=64
BS_PER_GPU_AMP=128
NUM_STEPS=10
CONFIG=LambdaSAEHD_liae_128_128_64_64
LOG_PATH=log_20200717
SRC_PATH=/tmp/ubuntu/_src/Dr_Fauci/WholeFace/_Custom_Batches/aligned
DST_PATH=/tmp/ubuntu/_src/Trey_TrainingData/WholeFace/TreyEgg_WF

. venv/bin/activate 

#./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 off $BS_PER_GPU_FP32 $LOG_PATH

#./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 on $BS_PER_GPU_FP32 $LOG_PATH

#./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 on $BS_PER_GPU_AMP $LOG_PATH
