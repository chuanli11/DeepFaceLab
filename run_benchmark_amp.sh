#!/bin/bash
CONFIG=${1:-LambdaSAEHD_jw_liae_ud_512_256_128_128}
NUM_STEPS=${2:-0}
BS_PER_GPU_FP32=${3:-16}
BS_PER_GPU_AMP=${4:-2}
LOG_PATH=${5:-jwhite}
SRC_PATH=${6:-~/data/dfl/Gordon_face_small}
DST_PATH=${7:-~/data/dfl/Snowden_face_small}
API=${8:-dfl}
OPT=${9:-adam}
LR=${10:-0.0001}
DECAY_STEP=${11:-1000}

. venv-tf-1.15.3/bin/activate

wait $! 

./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 off $BS_PER_GPU_FP32 $LOG_PATH tf1-multi adam 0.0001 1000

# wait $! 

# ./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 off $BS_PER_GPU_FP32 $LOG_PATH dfl


# wait $! 

# ./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 on $BS_PER_GPU_FP32 $LOG_PATH tf1

# wait $! 

# ./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 on $BS_PER_GPU_AMP $LOG_PATH dfl rmsprop 0.0001 1000
