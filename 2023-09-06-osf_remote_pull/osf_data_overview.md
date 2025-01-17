Flavivirus Data Overview
================

## Overview

This script provides a brief demonstration on how to import data
directly from an Open Science Framework project website (OSF). Generally
it’s best to use GitHub for code rather than data storage; OSF provides
an inexpensive (free) and secure (duel authentication) location to store
the data.

### Libraries

Load needed libraries.

The heavy lifting is performed by the [**osfr
package**](https://cran.r-project.org/web/packages/osfr/index.html),
which is available on CRAN, but an equivalent Python version is
available from [**osfclient**](https://github.com/osfclient/osfclient).
Other packages here are just used to display imported data.

``` r
library(osfr) # OSF package
library(yaml) # yaml tools
library(tidyverse) #data wrangling
library(sf) #spatial data
library(viridis) # color palette
library(here) # directory management
```

### OSF Authentication

Because the flavivirus detection data is stored in a secure OSF
directory, a *personal access token* (PAT) is needed to access, read,
and write to the project remotely. Once a PAT is generated from your OSF
profile (see: https://docs.ropensci.org/osfr/articles/auth), it can be
set as an environment variable and be recognized by *osfr*, the OSF
R-package.

This demo is being run from a GitHub repo where my personal PAT is
stored in a *secrets.yml* file.

``` r
# Read the PAT (must) create your own secrets.yml and PAT, this is one of mine)
my_osf_pat <- read_yaml(here("secrets.yml"))

osf_auth(my_osf_pat$osf) #authenticate to OSF
```

    Registered PAT from the provided token

### Read OSF Project

The WNV project data is located on OSF here: https://osf.io/6w7sf/ and
the data is stored in the `Disease Data` component (sub directories are
called `components` on OSF) of the main directory here:
https://osf.io/r2z5k/

**Note:** You must have been granted access to the OSF project
directories above for the hyperlinks to function properly.

The last part of the data component’s URL includes the GUID r2z5k, which
is used to read the directory with the *osf_retrieve_node()* function.

``` r
wnv_project <- osf_retrieve_node("r2z5k") #Read the data  
   
#View the uploaded data files
wnv_project %>%
  osf_ls_files() #tibble with file names and formats (.sas7bat, .csv, .xlsx, etc)    
```

    # A tibble: 9 × 3
      name                                     id                       meta        
      <chr>                                    <chr>                    <list>      
    1 wnvaviancounty.sas7bdat                  63a3402bc71a7101c715199b <named list>
    2 human_nonneuroinvasive_wnv_1999-2020.csv 63a3402eca8be701a1e5a105 <named list>
    3 nonhuman_wnv_2003-2019.csv               63a3402f7b5c800195227c39 <named list>
    4 wnvmosqcounty.sas7bdat                   63a3402f807cf9019dae4772 <named list>
    5 human_neuroinvasive_wnv_2000-2021.csv    63a34031ca8be7018fe5aba1 <named list>
    6 nonhuman_wnv_eee_2019-2020.xlsx          63a340317b5c80019c22702e <named list>
    7 wnvvetcounty.sas7bdat                    63a34035c71a7101c71519ab <named list>
    8 data_description_122122.docx             63a3406aca8be701a1e5a174 <named list>
    9 counties_poly                            63cecf96414aee03948c6cf5 <named list>

### Local Download

Download files to a local directory (**Warning:** If directory is within
GitHub, ensure it is included on the *.gitignore* file to avoid
posting/copying the data to the repo where other might access it)

``` r
#Copy the file names
wnv_file_names <- wnv_project %>%
                  osf_ls_files() 

#In addition to data files, that counties_poly folder includes a US Census boundary file (ESRI shapefile) 

#download all files to a 'local/data' directory
osf_download(wnv_file_names, 
             path = here("local/data"),
             conflicts = "overwrite")
```

    Requesting folder 'counties_poly' from OSF

    Downloaded 4 file(s) from OSF folder 'counties_poly'

    # A tibble: 9 × 4
      name                                     id            local_path meta        
      <chr>                                    <chr>         <chr>      <list>      
    1 counties_poly                            63cecf96414a… D:/Github… <named list>
    2 wnvaviancounty.sas7bdat                  63a3402bc71a… D:/Github… <named list>
    3 human_nonneuroinvasive_wnv_1999-2020.csv 63a3402eca8b… D:/Github… <named list>
    4 nonhuman_wnv_2003-2019.csv               63a3402f7b5c… D:/Github… <named list>
    5 wnvmosqcounty.sas7bdat                   63a3402f807c… D:/Github… <named list>
    6 human_neuroinvasive_wnv_2000-2021.csv    63a34031ca8b… D:/Github… <named list>
    7 nonhuman_wnv_eee_2019-2020.xlsx          63a340317b5c… D:/Github… <named list>
    8 wnvvetcounty.sas7bdat                    63a34035c71a… D:/Github… <named list>
    9 data_description_122122.docx             63a3406aca8b… D:/Github… <named list>

This can also be done one file at a time, in a loop or function as
needed.

``` r
#Example: just download file 5
wnv_file_names$name[5] # file name
```

    [1] "human_neuroinvasive_wnv_2000-2021.csv"

``` r
wnv_file_names$id[5] # file id code
```

    [1] "63a34031ca8be7018fe5aba1"

``` r
osf_retrieve_file(wnv_file_names$id[5]) %>% #use the id code to select files
                osf_download(conflicts = "overwrite", path = here("local/data")) #overwrite previous file 
```

    # A tibble: 1 × 4
      name                                  id               local_path meta        
      <chr>                                 <chr>            <chr>      <list>      
    1 human_neuroinvasive_wnv_2000-2021.csv 63a34031ca8be70… D:/Github… <named list>

### Read Example Data

Reading the text file with human neuroinavsive West Nile Disease as an
example.

``` r
neuro_invasive <- read_csv(here("local/data/human_neuroinvasive_wnv_2000-2021.csv"))
```

    Rows: 68376 Columns: 6
    ── Column specification ────────────────────────────────────────────────────────
    Delimiter: ","
    chr (4): fips, county, state, location
    dbl (2): year, count

    ℹ Use `spec()` to retrieve the full column specification for this data.
    ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
head(neuro_invasive)
```

    # A tibble: 6 × 6
      fips  county  state   location         year count
      <chr> <chr>   <chr>   <chr>           <dbl> <dbl>
    1 01001 Autauga Alabama Alabama-Autauga  2000     0
    2 01001 Autauga Alabama Alabama-Autauga  2001     0
    3 01001 Autauga Alabama Alabama-Autauga  2002     1
    4 01001 Autauga Alabama Alabama-Autauga  2003     0
    5 01001 Autauga Alabama Alabama-Autauga  2004     0
    6 01001 Autauga Alabama Alabama-Autauga  2005     0

``` r
range(neuro_invasive$year)
```

    [1] 2000 2021

Quick bar plot

``` r
bar_plot <- neuro_invasive %>%
  group_by(year) %>%
  summarise(Total = sum(count, na.rm=T))

ggplot(bar_plot, aes(year, Total)) +
  geom_bar(stat="identity") +
  xlab("Year") +
  ylab("Total Cases") +
  theme_bw()
```

![](osf_data_overview_files/figure-commonmark/unnamed-chunk-7-1.png)

### Get GeoBoundary File

This is an older, county-level shapefile (ESRI), updated ones are
available here:
https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.html

``` r
counties = read_sf(here("local/data/counties_poly/counties.shp"))

# Join 2-digit state code to 3-digit county code
counties$STCO_FIPS <- paste0(counties$STATE, counties$COUNTY) 

counties %>% 
  ggplot() +
  geom_sf() +
  theme_bw()
```

![](osf_data_overview_files/figure-commonmark/unnamed-chunk-8-1.png)

Filter to only 2020, add data to boundary file by FIPS Code, and plot

``` r
cases_2020 <- neuro_invasive %>%
  filter(year == 2020) %>%  #filter data
  group_by(fips, county, state) %>%
  summarise(Count = sum(count))
```

    `summarise()` has grouped output by 'fips', 'county'. You can override using
    the `.groups` argument.

``` r
counties$cases_2020 <- with(cases_2020, #match by FIPS
                        Count[match(
                           counties$STCO_FIPS,
                                    fips)])

counties$cases_2020[counties$cases_2020 == 0] = NA #setting to NA for the plot visual


ggplot() +
   geom_sf(data = counties, aes(fill = cases_2020)) + 
        scale_fill_viridis(name="Nero-Invasive WNV Cases 2020", 
                           discrete=F, option = "viridis",
                           direction = -1,
                           na.value = "white") +  
        xlab(" ") +
        ylab(" ") +
        theme(panel.grid.minor = element_blank(),
              panel.grid.major = element_blank(),
              panel.background = element_blank(),
              plot.background = element_blank(),
              panel.border = element_blank(),
              legend.position = "bottom",
              legend.title = element_text(size = 16, face = "bold"),
              axis.title.x =  element_blank(),
              axis.text.x =  element_blank(),
              axis.title.y =  element_blank(),
              axis.text.y =  element_blank(),
              axis.ticks = element_blank(),
              plot.title = element_blank())
```

![](osf_data_overview_files/figure-commonmark/unnamed-chunk-9-1.png)
