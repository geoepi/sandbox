#!/bin/bash
#SBATCH --job-name=simdat
#SBATCH -A disease_ecology
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH -t 00:05:00
#SBATCH --mem-per-cpu=1G

# cd /90daydata/disease_ecology

module purge
module load udunits
module load proj
module load geos
module load gdal
module load r/4.5
echo "Running as user: $(whoami)"
echo "Hostname: $(hostname)"
echo "Allocated cores: $SLURM_CPUS_PER_TASK"
echo "Allocated memory per core: $SLURM_MEM_PER_CPU MB"

Rscript --no-save --no-restore simdat.R