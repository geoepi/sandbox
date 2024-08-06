# Informal SCINet Training
2024-08-06

- [Linked Resources](#linked-resources)
- [Discussion Topics](#discussion-topics)
- [Terminal (command line)](#terminal-command-line)
- [Submit Batch](#submit-batch)

## Linked Resources

#### GeoEpi Notebook

Similiar Info Here:
https://geoepi.github.io/Notebook/proj_management.html

#### SCINet Access Info

Access Info: https://scinet.usda.gov/guides/access/web-based-login

#### Access ATLAS

Link: https://atlas-ood.hpc.msstate.edu/

#### Access CERES

Link: http://ceres-ood.scinet.usda.gov/

#### Globus File Transfer

Link: https://www.globus.org/

## Discussion Topics

### Login and Directories

1.  Login to OnDemand (try both Atlas and Ceres)

<!-- -->

1.  Use of PIV card now preferred, but ssh from PowerShell possible  
2.  Note: Tabs across top of page to access interactive GUI\`s, Files,
    and terminals.  

<!-- -->

2.  `Files` tab: Navigable directory via web interface

<!-- -->

1.  Find, create, and create directories  
2.  `Upload` and `Download` options (click, drag, and drop style)  
3.  Web interface good for smaller data, Globus recommended for big
    data  

<!-- -->

3.  Where to save, keep, and archive data?  
    A. **Home** directory: Very small storage, good for individual
    software installs B. **Project** directories: Project-specific, look
    at *flavivirus_geospatial* and *fadru_fmd* projects as examples. i.
    Same project names used on Ceres, Atlas, and Juno  
    ii. Size determined by P.I.’s, may be increased as needed iii. This
    is where computational work is performed C. **90daydata** directory:
    includes a project-specific directory *unlimited* storage, but
    deleted after 90days of being idle.  
    i. Best place for staging big data prior to prepossessing  
    ii. Pull it into the **Project** directory as needed. D. **Juno**
    directory: Long-term data archiving. Typically used when project is
    complete to create enduring data record.

### Globus

1.  See recoomendations on SCINet here [Scinet:
    Globus](https://scinet.usda.gov/guides/data/datatransfer)  
2.  Use of ORCID suggested for credentials and authentication.  
3.  Search for Ceres and Atlas in the `Collection` box, use
    `SCINet-Atlas` and `SCINet-Ceres`  
4.  Open side-by-side windows to view files between HPCs, or between
    HPCs and your local machine.  
5.  Select files, click `Start ->` arrow button to transfer

<div>

> **Atlas Authentication Error**
>
> During the live demo, John received an intermittent warning about
> transfer failing due to unsuccessful authentication to Atlas. If you
> encounter a similar issue, go to the settings-\>Identity options on
> Globus and ensure that you do not have a red “X” next to your
> credentials. If you do, copy your identity information (ID code and
> username) and send it to SCINet support so that your authentication
> info can be updated. This fixed John’s issue.

</div>

## Terminal (command line)

1.  Open terminals  
2.  Navigate and create directories  
3.  Scroll through installed software `module spider`  
4.  Find available R versions `module spider r`  
5.  Choose and R version `module spider r/4.4.0`  
6.  Load module `module load r/4.4.0` then open R using `R`  
7.  Install packages. If asked, reply *yes* to use a new directory. This
    will install the package in your **Home** directory.

## Submit Batch

1.  Example in this directory to run a linear regression using
    *lm()*. A.
    [test_lm.sh](https://github.com/geoepi/sandbox/blob/main/2024-08-06-informal_training/test_lm.sh):
    Unix shell script listing rquested HPC resources and filename of
    script to run.  
    B.
    [run_on_hpc.R](https://github.com/geoepi/sandbox/blob/main/2024-08-06-informal_training/run_on_hpc.R):
    R-script with code to load data, run model, and save results.  
    C.
    [test_data.rds](https://github.com/geoepi/sandbox/blob/main/2024-08-06-informal_training/test_data.rds):
    Example data to perform regression.  
    D.
    [demo_script_lm.R](https://github.com/geoepi/sandbox/blob/main/2024-08-06-informal_training/demo_script_lm.R):
    R-Script used to generate and save *test_data.rds*  
2.  Open terminal  
3.  Navigate to desired working directory.  
4.  Submit the shell script using `sbatch test_lm.sh`

<div>

> **Reminder: Line break error**
>
> During the live demo, we received the following error when attempting
> to submit the shell script:  
> \> \[john.humphreys@ceres fadru_fmd\]\$ sbatch test_lm.sh  
> \> sbatch: error: Batch script contains DOS line breaks ()
>
> To resolve this issue, we used `dos2unix`  
> \> \[john.humphreys@ceres fadru_fmd\]\$ dos2unix test_lm.sh  
> \> dos2unix: converting file test_lm.sh to Unix format…
>
> The sbatch was then succesful: \> \[john.humphreys@ceres fadru_fmd\]\$
> sbatch test_lm.sh  
> \> Submitted batch job 12937586

</div>
