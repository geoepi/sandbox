
# Installing core spatial packages and r-INLA
Spatial r-packages can be tricky to install due to needing to link to various modules (e.g., **gdal**).  The r-INLA package is dependent of the spatial packages.

## Start an interactive R session 
Works best when a development node is used; rather than a login or compute node
The *account=* is a project directory you have access to use.
```
srun --account=disease_ecology --partition=development --nodes=1 --ntasks=4 --pty bash
```

## Load modules 
This is often an overkill, *sdunits* and *gdal* are the most critical.
```
module purge
module load udunits
module load gdal
module load proj
module load geos
module load curl # see note below
```

Note that 'module load curl' is no longer recommended by SCInet IT in ATLAS as R uses the system curl, so loading an independent one can cause issues in specific instances.

## Load r/4.5
```
module load r/4.5
```

## Start R Session
```
R --vanilla --no-save
```

## Install **units** package
Need to install this dependency first
```
install.packages("units", configure.args="--with-udunits2-lib=$UDUNITS_ROOT/lib --with-udunits2-include=$UDUNITS_ROOT/include")
```

## Install R-Spatial packages
```
install.packages(c("sf", "terra"), configure.args=c(
"--with-proj-lib=$PROJ_ROOT/lib64", 
"--with-proj-include=$PROJ_ROOT/include",
"--with-proj-share=$PROJ_ROOT/share",
"--with-proj-data=$PROJ_LIB"))
```

## R-INLA
Before installing INLA, restart R.

Quit current session
```
q()
```

Without stopping modules, changing r-version, or reloading them if you they were stopped
```
R --vanilla --no-save
```

## Install r-INLA
Testing version recommended
```
install.packages("INLA",repos=c(getOption("repos"),INLA="https://inla.r-inla-download.org/R/testing"), dep=TRUE)
```

## Linux Binary install
If not done automatically during base r-INLA install
```
inla.binary.install()
```

As of January 2026, SCInet IT advises to pick the binary install alternative that includes 'Rocky linux 9.x'.


## That should be it!
