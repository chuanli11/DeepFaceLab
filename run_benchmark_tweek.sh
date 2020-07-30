#!/bin/bash
CONFIG=${1:-LambdaSAEHD_cl_liae_ud_gan_3_416_256_128_128_32}
NUM_STEPS=${2:-50}
BS_PER_GPU_FP32=${3:-8}
BS_PER_GPU_AMP=${4:-16}
LOG_PATH=${5:-log_tweek}
SRC_PATH=${6:-~/data/dfl/Gordon_face_small}
DST_PATH=${7:-~/data/dfl/Snowden_face_small}
API=${8:-dfl}

. venv-tf-1.15.3/bin/activate

# wait $! 

# ./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 off $BS_PER_GPU_FP32 $LOG_PATH tf1

# wait $! 

# ./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 off $BS_PER_GPU_FP32 $LOG_PATH dfl


# wait $! 

# ./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 on $BS_PER_GPU_FP32 $LOG_PATH tf1

wait $! 

./benchmark.sh benchmark/config/config_${CONFIG} $NUM_STEPS $SRC_PATH $DST_PATH float32 on $BS_PER_GPU_AMP $LOG_PATH tf1
