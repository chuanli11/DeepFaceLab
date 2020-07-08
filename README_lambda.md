# Lambda Notes

### Install on Ubuntu (with Lambda Stack 18.04)

```
git clone https://github.com/chuanli11/DeepFaceLab.git && \
cd DeepFaceLab && \
virtualenv -p /usr/bin/python3.6 venv && \
. venv/bin/activate && \
pip install -r requirements-cuda.txt
```

### Get the best test data

```
mkdir data/trump
mkdir data/fauci

# copy trump.mp4 and fauci.mp4 to these folders
```

### Usage

Step one: videoed

```
python main.py videoed extract-video --input-file=data/trump/trump.mp4 --output-dir=data/trump/output --output-ext=png --fps=10 && \
python main.py videoed extract-video --input-file=data/fauci/fauci.mp4 --output-dir=data/fauci/output --output-ext=png --fps=2
```

Step two: extract

1080 x 1920 Image
GPU utli: spikes between 20% - 50% on a single Quadro RTX 8000
GPU mem : 5GB

```
python main.py extract --detector=s3fd --input-dir=data/trump/output --output-dir=data/trump/face --output-debug --face-type=whole_face --force-gpu-idxs=0 && \
python main.py extract --detector=s3fd --input-dir=data/fauci/output --output-dir=data/fauci/face --output-debug --face-type=whole_face --force-gpu-idxs=0
```

Step three: train

```
rm -rf output && \
python main.py train --training-data-src-dir=data/fauci/face --training-data-dst-dir=data/trump/face --model-dir output --model Lambda --force-gpu-idxs 0 --no-preview --force-model-name lambda-t-f
```


### Misc

```
nvidia-smi --query-gpu=utilization.memory --format=csv -l 5
```