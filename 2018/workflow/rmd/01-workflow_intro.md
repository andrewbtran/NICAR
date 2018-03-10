File organization best practices
========================================================
author: Andrew Ba Tran (@abtran)
date: 03/10/2018
autosize: true

Why?
========================================================

The goal of reproducible data analysis is to tie specific instructions to data analysis and experimental data so that scholarship can be recreated, better understood and verified.

For journalists
- Builds trust among readers
- Enhances transparency
- Simplifies peer review
- Promotes community


Thanks
========================================================

These are all things I picked up from browsing other presentations and repos.

Much thanks to [Jenny Bryan](https://github.com/jennybc) and [Joris Muller](http://blog.jom.link/) from whom I cobbled many of these ideas and practices from. 

Also to BuzzFeed, FiveThirtyEight, ProPublica, Chicago Tribune, Los Angeles Times, and TrendCT.org

Purpose of a clear data analysis workflow
========================================================

- Check analysis and track errors
- Share results with colleagues for stories or editing
- Send methodology to sources for bullet-proofing
- To easily adjust when presented with new data
- Easily switch between work environments (desktop and laptop)
- Scavenge and repurpose code in future projects

Constraints
========================================================

- Workflow has to be platform agnostic
- Easy to deploy for yourself and others
- Free open source software
- Input has to be real raw data in whatever format it is (and wherever it is)
- But have a backup for when internet is not accessible
- Output has to work -- whether html, PDF, or web app
- IDE agnostic (be able to run it from a command line without Rstudio)


Four main components to workflow
========================================================

1. Software
  - R
  - Rstudio
  - Git for version control
2. Clear file organization
3. One R script to pull it all together
4. Hosting the html output internally or publicly with Github pages

Use projects to organize
========================================================
<img src="images/project.png" height="500">

Do not dump your scripts into a folder
========================================================
<img src="images/folder_rscripts.png" height="500">

One folder per project
========================================================

- RStudio project
- Git repo
- Can run parallel projects

<img src="images/multiple_projects.png">

Use portable file paths - DO NOT USE setwd()
========================================================

- Try the `here` package.

```
library(here)
#> here() starts at /Users/IRE/Projects/NICAR/2018/workflow
here()
#> [1] "/Users/IRE/Projects/NICAR/2018/workflow"
```
```
here("Test", "Folder", "text.txt")
#> [1] "/Users/IRE/Projects/NICAR/2018/workflow/Test/Folder/test.txt"
cat(readLines(here("Test", "Folder", "text.txt")))
#> You found the text file nested in these subdirectories!
```

Files organization (at minimum)
========================================================
```
name_of_projec
|--data
    |--2017report.csv
    |--2016report.pdf
    |--summary2016_2017.csv
|--docs
    |--01-analysis.Rmd
    |--01-analysis.html
|--scripts
    |--exploratory_analysis.R
|--name_of_project.Rproj
|--run_all.R
```


Files organization (optimal)
========================================================

```
name_of_project
|--raw_data
    |--WhateverData.xlsx
    |--2017report.csv
    |--2016report.pdf
|--output_data
    |--summary2016_2017.csv
|--rmd
    |--01-analysis.Rmd
|--docs
    |--01-analysis.html
    |--01-analysis.pdf
    |--02-deeper.html
    |--02-deeper.pdf
|--scripts
    |--exploratory_analysis.R
    |--pdf_scraper.R
|--name_of_project.Rproj
|--run_all.R
```

Create the folders
========================================================
```
folder_names <- c("raw_data", "output_data", "rmd", "docs", "scripts")

sapply(folder_names, dir.create)
```

Interested in tidy paths?
========================================================

Check out the [`fs` library](http://fs.r-lib.org/).

```
paths <- file_temp() %>%
  dir_create() %>%
  path(letters[1:5]) %>%
  file_create()
paths
```

Organization principles
========================================================

- Directory names are obvious to anyone looking
- Reports and the script files are not in the same directory
- Reports are sorted using 2-digit numbers. Tell your story clearly.


Source to the online data
========================================================

Normal data file
```
if (!file.exists("data/bostonpayroll2013.csv")) {

  dir.create("data", showWarnings = F)
  download.file(
  "https://website.com/data/bostonpayroll2013.csv",
  "data/bostonpayroll2013.csv")
}

payroll <- read_csv("data/bostonpayroll2013.csv")
```

Source to the online data
========================================================

Dealing with a zip file
```
if (!file.exists("data/employment/2016-12/FACTDATA_DEC2016.TXT")) {
  
  dir.create("data", showWarnings = F)
  temp <- tempfile()
  download.file(
  "https://website.com/data/bostonpayroll2013.zip",
  temp)
  unzip(temp, exdir="data", overwrite=T)
  unlink(temp)
}

payroll <- read_csv("data/bostonpayroll2013.csv")
```

Operate without a net
========================================================

**Never** save workspace to .RData on exiting RStudio and uncheck Restore .RData on startup.

This will make sure you've optimized your data ingesting and cleaning process and aren't working with a misstep in your process.

<img src="images/cut_the_cord.png" height="300">

Efficient way to deal with packages
========================================================

```
pkgs <- c('reshape2','geojson','readxl','ggplot2', 'leaflet','httr','rgeolocate','shiny','sp','dplyr', 'widyr', 'slickR', 'ggraph', 'svglite', 'geojsonio')

check <- sapply(pkgs,require,warn.conflicts = TRUE,character.only = TRUE)
if(any(!check)){
    pkgs.missing <- pkgs[!check]
    install.packages(pkgs.missing)
    check <- sapply(pkgs.missing,require,warn.conflicts = TRUE,character.only = TRUE)
  }
  
```

Dealing with Deprecated Functions
========================================================

The [`here` package](https://rstudio.github.io/packrat/) creates a snapshot of the versions you are using in a workspace.

- Isolated: Installing a new or updated package for one project won’t break your other projects, and vice versa.
- Portable: Easily transport your projects from one computer to another, even across different platforms. 
- Reproducible: Packrat records the exact package versions you depend on, and ensures those exact versions are the ones that get installed wherever you go.

```
library(packrat)
init()
status()
restore()
```
