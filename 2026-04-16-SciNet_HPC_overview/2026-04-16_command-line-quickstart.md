HPC Quick Start: Command Line
================
4/16/26

- <a href="#navigating-the-file-system"
  id="toc-navigating-the-file-system">1. Navigating the File System</a>
- <a href="#files-and-folders" id="toc-files-and-folders">2. Files and
  Folders</a>
- <a href="#viewing-and-editing-files"
  id="toc-viewing-and-editing-files">3. Viewing and Editing Files</a>
- <a href="#hpc-specific-essentials" id="toc-hpc-specific-essentials">4.
  HPC-Specific Essentials</a>

## 1. Navigating the File System

The HPC environment is organized in a tree-like directory structure. \*
`pwd` (**P**rint **W**orking **D**irectory): Shows exactly where you
are. \* `ls`: Lists the files and folders in your current directory. \*
`ls -l`: Lists files with details (size, permissions, date).  
\* `ls -ld`: Who has access to the group.  
\* `getent group proj-[project name]`: Who belongs to a group.  
\* `cd [folder]`: **C**hange **D**irectory to a specific folder. \*
`cd ..`: Move up one level (to the parent directory). \* `cd ~`: Return
immediately to your **Home** directory.

## 2. Files and Folders

- `mkdir [name]`: **M**ake a new **dir**ectory (folder).
- `cp [source] [destination]`: **C**opy a file or folder.
  - `cp -r`: Required to copy a folder and everything inside it.
- `mv [source] [destination]`: **M**ove or **Rename** a file/folder.
- `rm [file]`: **R**emove (delete) a file. **Warning: Deletions are
  permanent.**
  - `rm -r [folder]`: Deletes a folder and all its contents.
- `touch [filename]`: Creates an empty file.

## 3. Viewing and Editing Files

- `nano [file]`: A simple text editor.
  - `Ctrl + O`: *Write Out* (save changes)  
  - `Enter`: Confirmation at bottom of screen with file name.
  - `Ctrl + X`: Exit nano, back to terminal.  
- `cat [file]`: Dumps the entire contents of a file onto the screen.
- `head -n 10 [file]`: Shows the first 10 lines of a file.
- `tail -n 10 [file]`: Shows the last 10 lines (useful for checking log
  files).
- `less [file]`: Opens a file for viewing (use arrow keys to scroll,
  press `q` to quit).

## 4. HPC-Specific Essentials

On an HPC, you don’t run heavy computations directly on the login node.
You use a **Scheduler** (Slurm). \* `sbatch [script.sh]`: Submits a job
script to the computing queue. \* `squeue -u [username]`: Checks the
status of your submitted jobs. \* `scancel [job_id]`: Cancels a running
or pending job.
