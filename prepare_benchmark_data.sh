#!/bin/bash

DATA_PATH=${1:-~/data}

mkdir -p ${DATA_PATH}/dfl

python main.py videoed extract-video --input-file=${DATA_PATH}/faces/Gordon.mp4 --output-dir=${DATA_PATH}/dfl/Gordon --output-ext=png --fps=10 && \
python main.py videoed extract-video --input-file=${DATA_PATH}/faces/Snowden.mp4 --output-dir=${DATA_PATH}/dfl/Snowden --output-ext=png --fps=1


python main.py extract --detector=s3fd --input-dir=${DATA_PATH}/dfl/Gordon --output-dir=${DATA_PATH}/dfl/Gordon_face --output-debug --face-type=full_face --force-gpu-idxs=0 --image-size=512 --jpeg-quality=100 --max-faces-from-image=0 && \
python main.py extract --detector=s3fd --input-dir=${DATA_PATH}/dfl/Snowden --output-dir=${DATA_PATH}/dfl/Snowden_face --output-debug --face-type=full_face --force-gpu-idxs=0 --image-size=512 --jpeg-quality=100 --max-faces-from-image=0
