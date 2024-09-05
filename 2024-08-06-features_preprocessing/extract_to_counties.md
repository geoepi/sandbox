Extract Features to Counties
================

- <a href="#overview" id="toc-overview">Overview</a>
- <a href="#shell-script" id="toc-shell-script">Shell Script</a>
- <a href="#extract-earth-environment"
  id="toc-extract-earth-environment">Extract Earth Environment</a>
- <a href="#extract-habitat-heterogeneity"
  id="toc-extract-habitat-heterogeneity">Extract Habitat Heterogeneity</a>
- <a href="#elevation-and-topo" id="toc-elevation-and-topo">Elevation and
  Topo</a>
- <a href="#prism-climate" id="toc-prism-climate">Prism Climate</a>

## Overview

This code is a follow up to the [Data Download and
Preprocessing](https://github.com/geoepi/GeoAI-Flavivirus2/blob/main/features_preprocessing/download_preprocessing_overview.md)
script and provides batch script to extract previously downloaded
spatial data to study area counties. County-level data is then written
to *.csv* files for later use.

**NOTE 1:** This script requires that libraries have already been
installed on the HPC as described in the **Data Download and
Preprocessing** script.

**NOTE 2:** Text file versions of the below scripts are available in the
`/batch/` directory linked
[HERE](https://github.com/geoepi/GeoAI-Flavivirus2/tree/main/features_preprocessing/batch).

## Shell Script

Generally, the shell script (*.sh*) will look something lke this:

    #!/bin/bash

    #SBATCH --job-name=extract  

    #SBATCH -A flavivirus_geospatial

    #SBATCH -N 1

    #SBATCH -n 8  

    #SBATCH -t 2:59:00  

    #SBATCH --mem-per-cpu=10M    

    module --ignore-cache load gdal
    module --ignore-cache load proj
    module --ignore-cache load r/4.4           
    R CMD BATCH --no-save --no-restore prism_extract_county.txt

Then, the batch scripts as executed in R will look like the below:

## Extract Earth Environment

<details open>
<summary>Hide code</summary>

``` r
library(terra)
library(dplyr)
library(readr)
library(stringr) 
  
# main directory
target_directory <- "/90daydata/flavivirus_geospatial/raw_sp_features"
   
# spatial spatVect to define grid cells
counties <- vect(paste0(target_directory, "/assets/counties/south_counties.shp"))

# get file names
file_names <- list.files(path = paste0(target_directory, "/earth_env"),
                         pattern="*.tif$", full.names=T, recursive=T) 
# organize file names
file_names_df <- data.frame(path=file_names)

# get label for column name Class == landcover type
file_names_df$class <- str_extract(file_names_df$path, "class_\\d+")

# data frame of fips code ordered same as in counties
tmp_df <- data.frame(fips=counties$fips)

# loop through each grid
for(i in 1:nrow(file_names_df)){
  
    tmp_raster <- rast(file_names_df$path[i])  # load one raster at a time
    
    counties <- project(counties, crs(tmp_raster)) # conversion to match projection
    
    # Extract values 
    mean_values <- as.data.frame(
      terra::extract(tmp_raster, counties, fun="mean", na.rm=TRUE)[,names(tmp_raster)]
    )
    
      colnames(mean_values) <- file_names_df$class[i]
    
    # Combine mean_values with Grid_ID
    tmp_df <- cbind(tmp_df, mean_values)
    
  }
  
  # extracted data
  write_csv(tmp_df, paste("/project/flavivirus_geospatial/feature_extract/", 
                           "earthenv_", Sys.Date(), ".csv", sep=""))
```

</details>

## Extract Habitat Heterogeneity

<details open>
<summary>Hide code</summary>

``` r
library(terra)
library(dplyr)
library(readr)
library(stringr) 
  
# main directory
target_directory <- "/90daydata/flavivirus_geospatial/raw_sp_features"
   
# spatial spatVect to define grid cells
counties <- vect(paste0(target_directory, "/assets/counties/south_counties.shp"))

# get file names
file_names <- list.files(path = paste0(target_directory, "/habitat_hetero"),
                         pattern="*.tif$", full.names=T, recursive=T) 
# organize file names
file_names_df <- data.frame(path=file_names)

# get label for column name
file_names_df <- file_names_df |>
  mutate(metric = basename(path),
         metric = str_extract(metric, "^[^_]+"))

# data frame of fips code ordered same as in counties
tmp_df <- data.frame(fips=counties$fips)

# loop through each grid
for(i in 1:nrow(file_names_df)){
  
    tmp_raster <- rast(file_names_df$path[i])  # load one raster at a time
    
    counties <- project(counties, crs(tmp_raster)) # conversion to match projection
    
    # Extract values 
    mean_values <- as.data.frame(
      terra::extract(tmp_raster, counties, fun="mean", na.rm=TRUE)[,names(tmp_raster)]
    )
    
      colnames(mean_values) <- file_names_df$metric[i]
    
    # Combine mean_values with Grid_ID
    tmp_df <- cbind(tmp_df, mean_values)
    
  }
  
  # extracted data
  write_csv(tmp_df, paste("/project/flavivirus_geospatial/feature_extract/", 
                           "habitat_hetero_", Sys.Date(), ".csv", sep=""))
```

</details>

## Elevation and Topo

<details open>
<summary>Hide code</summary>

``` r
library(terra)
library(dplyr)
library(readr)
library(stringr) 
  
# main directory
target_directory <- "/90daydata/flavivirus_geospatial/raw_sp_features"
   
# spatial spatVect to define grid cells
counties <- vect(paste0(target_directory, "/assets/counties/south_counties.shp"))

# get file names
file_names <- list.files(path = paste0(target_directory, "/elevation_topo"),
                         pattern="*.tif$", full.names=T, recursive=T) 
# organize file names
file_names_df <- data.frame(path=file_names)

# get label for column name
file_names_df <- file_names_df |>
  mutate(metric = basename(path),
         metric = str_extract(metric, "^[^_]+"))

# data frame of fips code ordered same as in counties
tmp_df <- data.frame(fips=counties$fips)

# loop through each grid
for(i in 1:nrow(file_names_df)){
  
    tmp_raster <- rast(file_names_df$path[i])  # load one raster at a time
    
    counties <- project(counties, crs(tmp_raster)) # conversion to match projection
    
    # Extract values 
    mean_values <- as.data.frame(
      terra::extract(tmp_raster, counties, fun="mean", na.rm=TRUE)[,names(tmp_raster)]
    )
    
      colnames(mean_values) <- file_names_df$metric[i]
    
    # Combine mean_values with Grid_ID
    tmp_df <- cbind(tmp_df, mean_values)
    
  }
  
  # extracted data
  write_csv(tmp_df, paste("/project/flavivirus_geospatial/feature_extract/", 
                           "topographic_", Sys.Date(), ".csv", sep=""))
```

</details>

## Prism Climate

<details open>
<summary>Hide code</summary>

``` r
# function to extract PRISM data

library(terra)
library(dplyr)
library(readr) 

target_directory <- "/90daydata/flavivirus_geospatial/raw_sp_features"

counties <- vect(paste0(target_directory, "/assets/counties/south_counties.shp"))

folders_to_process <- c("tmin", "tmax", "tmean", "ppt")

for(i in 1:length(folders_to_process)){
  
  target_folder <- folders_to_process[i]
  
  file_names <- list.files(path = paste0(target_directory, "/prism_climate","/", target_folder),       
                           pattern="*.bil$", full.names=T, recursive=T) 
                           
  # Convert file paths to data frame                           
  file_names_df <- data.frame(path=file_names)
  file_names_df$is_prov = grepl("provisional", file_names_df$path)
  file_names_df$date_seq <- sub(".*_([0-9]+)_bil\\.bil", "\\1", file_names_df$path)
  file_names_df$year <- as.integer(substr(file_names_df$date_seq, 1, 4)) 
  file_names_df$month <- as.integer(substr(file_names_df$date_seq, 5, 6)) 
  
  # create out_df with Grid_ID
  tmp_df <- data.frame(fips=counties$fips)
  
  for(j in 1:nrow(file_names_df)){
    
    tmp_raster <- rast(file_names_df$path[j])  # Use j for indexing
    
    tmp_raster <- project(tmp_raster, crs(counties))
    
    # Extract values and add to counties
    mean_values <- as.data.frame(
        terra::extract(tmp_raster, counties, fun="mean", na.rm=TRUE)[,names(tmp_raster)]
        )
        
    value_col_name <- paste(target_folder, file_names_df$year[j], file_names_df$month[j], sep="_") 
    
    colnames(mean_values) <- value_col_name
    
    # Combine mean_values with fips
    tmp_df <- cbind(tmp_df, mean_values)
    
  }
  
  # Output files
  write_csv(tmp_df, paste(target_directory, "prism_climate/county_extraction", 
                          paste0(target_folder, "_", Sys.Date(), ".csv"), sep="/"))
  
}
```

</details>
