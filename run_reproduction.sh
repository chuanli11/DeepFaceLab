#!/bin/bash
. venv-tf-1.15.3/bin/activate


get_and_create_model_path() {
    output_path=$1

    MODEL_DIR="${output_path}/model"

    mkdir -p $MODEL_DIR
    echo $MODEL_DIR
}


get_output_path() {
    config=$1
    idx=$2
    output_dir=$3
    api=$4
    amp=$5
    stage=$6

    MODEL=(${config//_/ })
    GPUS=(${idx//,/ })
    NUM_GPU=${#GPUS[@]}

    GPU_NAME="$(nvidia-smi -i 0 --query-gpu=gpu_name --format=csv,noheader | sed 's/ //g' 2>/dev/null || echo PLACEHOLDER )"

    OUTPUT_NAME=reproduce/${output_dir}/${config}_stage${stage}_${NUM_GPU}x${GPU_NAME}_bs${BS_PER_GPU}

    OUTPUT_NAME=${OUTPUT_NAME}_${api}

    if [ "$amp" == "on" ]; then
        OUTPUT_NAME="${OUTPUT_NAME}_amp"
    fi

    echo $OUTPUT_NAME
}


CONFIG=LambdaSAEHD_rep_512_256_128_128_32

API=tf1-multi
OPT=adam
DECAY_STEP=300
IDX=0,1
AMP=on
OUTPUT_PATH=LambdaSAEHD_rep_512_256_128_128_32
SRC_PATH=/mnt/data/chuan/data/_src/Dr_Fauci/WholeFace/_Custom_Batches/aligned
DST_PATH=/mnt/data/chuan/data/_src/Trey_TrainingData/WholeFace/TreyEgg_WF

output_path0=$(get_output_path $CONFIG $IDX $OUTPUT_PATH $API $AMP 0)
output_path1=$(get_output_path $CONFIG $IDX $OUTPUT_PATH $API $AMP 1)
output_path2=$(get_output_path $CONFIG $IDX $OUTPUT_PATH $API $AMP 2)

model_path0=$(get_and_create_model_path $output_path0)
model_path1=$(get_and_create_model_path $output_path1)
model_path2=$(get_and_create_model_path $output_path2)


TARGET_ITER=3000
BS_PER_GPU=8
LR=0.0001

wait $! 
./reproduce.sh ${CONFIG}_stage0 $TARGET_ITER $SRC_PATH $DST_PATH $AMP $BS_PER_GPU $IDX $API $OPT $LR $DECAY_STEP $output_path0

wait $!
cp -rf $model_path0 $output_path1


TARGET_ITER=3000
BS_PER_GPU=8
LR=0.00005

wait $! 
./reproduce.sh ${CONFIG}_stage1 $TARGET_ITER $SRC_PATH $DST_PATH $AMP $BS_PER_GPU $IDX $API $OPT $LR $DECAY_STEP $output_path1

wait $!
cp -rf $model_path1 $output_path2


TARGET_ITER=3000
BS_PER_GPU=8
LR=0.000025

./reproduce.sh ${CONFIG}_stage2 $TARGET_ITER $SRC_PATH $DST_PATH $AMP $BS_PER_GPU $IDX $API $OPT $LR $DECAY_STEP $output_path2
