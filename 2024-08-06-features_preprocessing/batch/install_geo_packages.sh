#!/bin/bash

#SBATCH --job-name=prism  

#SBATCH -A flavivirus_geospatial

#SBATCH -N 1

#SBATCH -n 8  

#SBATCH -t 1:59:00  

#SBATCH --mem-per-cpu=10M    

module --ignore-cache load gdal
module --ignore-cache load proj
module --ignore-cache load r/4.4		   
R CMD BATCH --no-save --no-restore install_geo_packages.txt