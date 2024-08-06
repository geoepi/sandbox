#!/bin/bash

#SBATCH --job-name=run_job1  

#SBATCH -N 1

#SBATCH -n 4  

#SBATCH -t 1:59:00  

#SBATCH --mem-per-cpu=10M    

module --ignore-cache load r/4.3.1		   
R CMD BATCH --no-save --no-restore run_on_hpc.R