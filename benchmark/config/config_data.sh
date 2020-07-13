#!/bin/sh
CONFIGS="\
LambdaSAEHD_liae_128_128_64_64 LambdaSAEHD_liae_256_128_64_64 LambdaSAEHD_liae_512_128_64_64 \
LambdaSAEHD_liae_128_128_64_64_syn LambdaSAEHD_liae_256_128_64_64_syn LambdaSAEHD_liae_512_128_64_64_syn \
"

GPU_IDXS="0 0,1 0,1,2,3 0,1,2,3,4,5,6,7 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15"