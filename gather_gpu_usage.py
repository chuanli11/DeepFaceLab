#!/usr/bin/env python3
import argparse
import matplotlib.pyplot as plt
import numpy as np

import pandas as pd

list_profile = ['temp', 'util', 'mem'] 
list_output_file = ['tmp.csv', 'util.csv', 'mem.csv']

def main():
	parser = argparse.ArgumentParser(description='Process some integers.')
	parser.add_argument('file_name', type=str,
	                    help='name of the thermal log file')
	parser.add_argument('--thermal_threshold', type=int, default=0,
	                    help='Threshold for the card to throttle')

	args = parser.parse_args()
	
	file_name = args.file_name
	thermal_threshold = args.thermal_threshold

	t = []
	throughput = []
	start = 0


	# # second, throughput, temp[, temp[, temp...]]
	# Get number of GPUs
	with open(file_name) as f:
		mark_count = 0
		line_count = 0
		for line in f:
			line_count += 1				
			if 'temperature.gpu' in line:
				mark_count += 1
			if mark_count == 2:
				num_gpu = line_count - mark_count
				break

	list_gpu = [str(i) for i in range(num_gpu)]

	df_temp = []
	df_util = []
	df_mem = []


	with open(file_name) as f:
		gpu_idx = 0
		temp = []
		util = []
		mem = []
		for line in f:
			if not 'temperature.gpu' in line:
				iterms = line.split(', ')
				temp.append(int(iterms[0]))
				util.append(int(iterms[1][:-1]))
				mem.append(float((iterms[2][:-4]))/1000)
			gpu_idx += 1

			if gpu_idx == 3:
				gpu_idx = 0

				if len(df_temp)==0:
					df_temp = pd.DataFrame([temp], columns=list_gpu)
					df_util = pd.DataFrame([util], columns=list_gpu)
					df_mem = pd.DataFrame([mem], columns=list_gpu)
				else:
					df_temp = df_temp.append(pd.DataFrame([temp], columns=list_gpu), ignore_index=True)
					df_util = df_util.append(pd.DataFrame([util], columns=list_gpu), ignore_index=True)
					df_mem = df_mem.append(pd.DataFrame([mem], columns=list_gpu), ignore_index=True)

				temp = []
				util = []
				mem = []

	df_temp.to_csv(list_output_file[0])
	df_util.to_csv(list_output_file[1])
	df_mem.to_csv(list_output_file[2])

if __name__ == '__main__':
	main()
