# Informal Github Training
2024-08-12

- [Linked Resources](#linked-resources)
- [Initial Setup](#initial-setup)
- [Create a Repo](#create-a-repo)
- [Adding Content](#adding-content)
- [RStudio, R-Project, and Git](#rstudio-r-project-and-git)

## Linked Resources

#### What’s Needed

1.  Download and install [RStudio](https://www.r-project.org/) and
    [GitHub Desktop](https://desktop.github.com/download/). Git is a
    command line application, GH Desktop is a GUI for Git, and GitHub is
    a web service. Git is installed with the Desktop app.

2.  Create GitHub user account @ https://github.com/

3.  A few R-packages need to be installed, including, the **here**
    package for directory management, the **usethis**package for
    authenticating to GitHub, and the …

#### GeoEpi Notebook

[GitHub
Elements](https://geoepi.github.io/Notebook/github_elements.html): A
checklist of basic GitHub skills to know.

[GH Repo
Components](https://geoepi.github.io/Notebook/repo_components.html):
Core structure, files, and directories suggested for a GitHub
repository, aka a *Repo*.

## Initial Setup

Tell RStudio where Git lives:  
1. Open RStudio  
2. Go to the `Terminal` CLI  
3. Find git: Type `which git` or `git --version`  
4. Navigate to Tools \> Global Options \> Git/SVN  
5. Ensure Git’s linked there (`\Program Files\Git\bin\git.exe`)  
6. May need to restart RStudio

**Authentication** is the porcess of letting GitHub know who you are.
This can be done using *use_git_config()* from the **usethis** package
to configure your the username and email. Use your GitHub account
username and email.

For example:

<details open>
<summary>Code</summary>

``` r
library(usethis)
use_git_config(user.name = "JohnH", user.email = "jmh09@my.fsu.edu")
```

</details>

## Create a Repo

Usually simplest to create it at the website first, then *clone* using
the Desktop GUI or command line. Though, you can create repos on your
local machine before (or without ever) sending them to GitHub (see,
`git init` [here](https://git-scm.com/docs/git-init)).

1.  Navigate to GitHub and create a repo for practice. (demo)  
2.  Next, copy the new repo to your local machine, that is, *clone* the
    repo.

To clone from the terminal:

    cd C:\Users\humph173\Documents\aa_training
    mkdir project_one
    cd project_one
    git clone https://github.com/JMHumphreys/test_repo.git
    cd test_repo

Next, let’s step through cloning with GH Desktop. (demo)

## Adding Content

Before talking about what *should* go into a repo, we’ll first look at
how to add files technically/generally and get them to GitHub.

Repo files can be added and managed in a number of ways, including from
the CLI.

For example:

    git add myfile.R

Then, whatever is added to the directory with the `.git` can be *pushed*
to GitHub online.

    git status
    git commit -m "initial commit"
    git push

Outside of RStudio Terminal, CLI can be performed for any git
directory. 1. Navigate to the new repo  
2. Right click, `Open git here`

All files added to the repo are automatically tracked by the GUI, let’s
take a look at that method. (demo)

### Needed Repo Stuff

Here’s a list of a few standard items to have in the repo: [GH Repo
Components](https://geoepi.github.io/Notebook/repo_components.html)

Personal Access Tokens (PAT), APIs, and other secret things…

<details open>
<summary>Code</summary>

``` r
usethis::create_github_token()
```

</details>

## RStudio, R-Project, and Git

A main benefit of integrating git and RStudio isn’t to have another
option for linking to Git, rather it’s to efficiently use git as part of
normal coding.

1.  Create an R-Project (in the repo folder, same name as repo)  
2.  Build a project (add content)  
3.  Commit and push to GitHub

Collaborate:  
1. Branching  
2. Pull Requests (PRs)  
3. Code review  
4. Merge
