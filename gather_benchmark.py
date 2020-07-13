import os
import pandas as pd

list_gpu_type = ['TeslaV100-SXM3-32GB']

path_config = 'benchmark/log_data'
output_file = 'benchmark/benchmark_data.csv'
list_config = [
'LambdaSAEHD_liae_128_128_64_64', 'LambdaSAEHD_liae_256_128_64_64', 'LambdaSAEHD_liae_512_128_64_64', \
'LambdaSAEHD_liae_128_128_64_64_syn', 'LambdaSAEHD_liae_256_128_64_64_syn', 'LambdaSAEHD_liae_512_128_64_64_syn', \
]
list_gpu_idxs = ['0', '0,1', '0,1,2,3', '0,1,2,3,4,5,6,7', '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15']

#path_config = 'benchmark/log'
#output_file = 'benchmark/benchmark.csv'
#list_config = [
#'LambdaSAEHD_liae_128_128_64_64', 'LambdaSAEHD_liae_128_128_64_64_syn', 'LambdaSAEHD_liae_256_128_64_64', 'LambdaSAEHD_liae_256_128_64_64_syn', \
#'LambdaSAEHD_liae_gan_128_128_64_64', 'LambdaSAEHD_liae_gan_128_128_64_64_syn', 'LambdaSAEHD_liae_gan_256_128_64_64', 'LambdaSAEHD_liae_gan_256_128_64_64_syn', \
#'LambdaSAEHD_liae_512_128_64_64', 'LambdaSAEHD_liae_512_128_64_64_syn', \
#'LambdaSAEHD_liae_128_256_128_128', 'LambdaSAEHD_liae_128_256_128_128_syn', \
#'LambdaSAEHD_liae_fs_128_128_64_64', 'LambdaSAEHD_liae_fs_128_128_64_64_syn', \
#'LambdaSAEHD_liae_bs_128_128_64_64', 'LambdaSAEHD_liae_bs_128_128_64_64_syn', \
#]
#list_gpu_idxs = ['0', '0,1', '0,1,2,3', '0,1,2,3,4,5,6,7', '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15']

pattern = "]["

def get_time(t_start, t_end):
    t_s = [float(t) for t in t_start.split(':')]
    t_e = [float(t) for t in t_end.split(':')]

    if t_e[0] < t_s[0]:
        t_e[0] += 24

    sec_s = 3600 * t_s[0] + 60 * t_s[1] + t_s[2]
    sec_e = 3600 * t_e[0] + 60 * t_e[1] + t_e[2]
    return sec_e - sec_s 


def get_throughput(gpu_type, config, num_gpu):
    log_file = path_config + '/' + config + '_' + str(num_gpu) + 'x' + gpu_type + '.txt'
    print(log_file)    
    count = 0
    time_second_iter = ''
    time_end = ''
    for i, line in enumerate(open(os.path.join(log_file))):
        if 'batch_size' in line:
            bs = line.split(' ')[13]
        if pattern in line:
            if count == 1:
                time_second_iter = line.split('][')[0][1:]
            count += 1
            time_end = line.split('][')[0][1:]
    t = get_time(time_second_iter, time_end) + 0.0001
    throughput = float(bs) * (count - 1) / t
    return throughput

list_row = []
for gpu_type in list_gpu_type:
    for gpu_idx in list_gpu_idxs:
        num_gpu = len(gpu_idx.split(','))
        list_row.append(str(num_gpu) + "x" + gpu_type)

df_throughput = pd.DataFrame(index=list_row, columns=list_config)


for gpu_type in list_gpu_type:
    for gpu_idx in list_gpu_idxs:
        for config in list_config:
            num_gpu = len(gpu_idx.split(','))
            throughput = get_throughput(gpu_type, config, num_gpu)
            df_throughput.at[str(num_gpu) + "x" + gpu_type, config] = throughput

df_throughput.to_csv(output_file)
