#!/bin/bash
CONFIG=${1:-LambdaSAEHD_liae_128_128_64_64}
NUM_STEPS=${2:-50}
BS_PER_GPU_FP32=${3:-1}
BS_PER_GPU_AMP=${4:-2}
LOG_PATH=${5:-log_20200717}
SRC_PATH=${6:-~/_src/Dr_Fauci/WholeFace/_Custom_Batches/aligned}
DST_PATH=${7:-~/_src/Trey_TrainingData/WholeFace/TreyEgg_WF}

. venv/bin/activate 

wait $! 

./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 off $BS_PER_GPU_FP32 $LOG_PATH

wait $! 

./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 on $BS_PER_GPU_FP32 $LOG_PATH

wait $! 

./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 on $BS_PER_GPU_AMP $LOG_PATH
