# Lambda Notes

### Install on Ubuntu (with Lambda Stack 18.04)

```
git clone https://github.com/chuanli11/DeepFaceLab.git && \
cd DeepFaceLab && \
virtualenv -p /usr/bin/python3.6 venv && \
. venv/bin/activate && \
pip install -r requirements-cuda.txt
```

### Data prepare

```
mkdir data/faces
```

copy src.mp4 and dst.mp4 to this folder


### Usage

Step one: videoed

```
python main.py videoed extract-video \
--input-file=~/data/faces/Snowden.mp4 \
--output-dir=~/data/dfl/Snowden \
--output-ext=png \
--fps=1

python main.py videoed extract-video \
--input-file=~/data/faces/Gordon.mp4 \
--output-dir=~/data/dfl/Gordon \
--output-ext=png \
--fps=10
```

Step two: extract

```
python main.py extract \
--detector=s3fd \
--input-dir=~/data/dfl/Snowden \
--output-dir=~/data/dfl/Snowden_face \
--output-debug \
--face-type=full_face \
--force-gpu-idxs=0 \
--image-size=512 \
--jpeg-quality=100 \
--max-faces-from-image=0


python main.py extract \
--detector=s3fd \
--input-dir=~/data/dfl/Gordon \
--output-dir=~/data/dfl/Gordon_face \
--output-debug \
--face-type=full_face \
--force-gpu-idxs=0 \
--image-size=512 \
--jpeg-quality=100 \
--max-faces-from-image=0
```

Step three: train

```
GPU_IDXS=0,1

rm -rf output && \
python main.py train \
--training-data-src-dir=~/data/dfl/Gordon_face \
--training-data-dst-dir=~/data/dfl/Snowden_face \
--model-dir output \
--model LambdaSAEHD \
--force-gpu-idxs $GPU_IDXS \
--no-preview \
--force-model-name lambda-gordon-snowden
```

### Benchmark

Use `benchmark/config/your_config_name.yaml` to configure the model. 

Use `benchmark.sh` to run test.

```
./benchmark.sh SETTING TARGET_ITER TRAINING_DATA_SRC_IDR TRAINING_DATA_DST_DIR
```

- `SETTING`: Configuration file. For example, `benchmark/config/config_all`
- `TARGET_ITER`: Number of iterations for each benchmark to run. Default: 50
- `TRAINING_DATA_SRC_DIR`: Path to src data. 
- `TRAINING_DATA_DST_DIR`: Path to dst data. 

Use `gather_benchmark.py` to create `csv` file.

### Misc

```
nvidia-smi --query-gpu=utilization.memory --format=csv -l 5
```
