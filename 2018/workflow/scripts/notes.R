# Setting up a reproducible data analysis workflow in R
# https://www.ire.org/events-and-training/event/3189/3643/

# You will save time, produce better results, create more trusted analyses,
# reduce risk of errors and encourage collaboration by implementing reproducible 
# data analysis workflow techniques for data journalism. 

# 1) We will be going over R Notebooks and RMarkdown to weave together narrative text 
# and code to produce elegantly formatted PDFs and HTML for sharing. 
# 2) We will walk through hosting these reports and raw data files on GitHub Pages. 
# 3) We will discuss best practices on how to structure your projects and repos. 
# 4) And if there is time, you will learn how to turn specific scripts into 
# generalized functions to be used in future analyses.

# The goal of reproducible data analysis is to tie specific instructions to data analysis 
# and experimental data so that scholarship can be recreated, 
# better understood and verified.

# Purpose of a clear data analysis workflow

# - Check analysis and track errors (?)
# - Share results to colleagues for stories or editing
# - Send my methodology to sources for bullet-proofing
# - To easily adjust when presented with new data
# - Easily switch between work environments (desktop and laptop)

# Constraints

# - Workflow has to be platform agnostic
# - Easy to deploy for yourself and others
# - Free open source software
# - Input has to be real raw data in whatever format it is (and wherever it is)
# - But have a backup for when internet is not accessible
# - Output has to work -- whether html, PDF, or web app
# - IDE agnostic (be able to run it from a command line without Rstudio)

# Four main components to workflow

# 1. Software
#   - R
#   - Rstudio
#   - Git for version control
# 2. Files organization
# 3. One R script to rule them all (?)
# 4. Hosting the html output internally or publicly with Github pages

# Files organization (at minimum)
## name_of_project
## --data
## --output
## --scripts
## --name_of_project.Rproj
## --run_all.R (if necessary)

# Files organization (big projects)
## name_of_project
## |--raw_data
##    |--WhateverData.xlsx
##    |--2017report.csv
##    |--2016report.pdf
## |--output_data
##    |--summary2016_2017.csv
## |--rmd
##    |--analysis.Rmd
## |--reports
##    |--01-analysis.html
##    |--01-analysis.pdf
##    |--02-deeper.html
##    |--02-deeper.pdf
## |--scripts
##    |--exploratory_analysis.R
##    |--pdf_scraper.R
## |--name_of_project.Rproj
## |--run_all.R (if necessary)

# NOTE: DO NOT USE setwd() 

# Organization principles
# - Directory names are obvious to anyone looking
# - Reports and the script files are not in the same directory
# - One report file = one R markdown file. One report file = on equestion, ideally. (?)
# - Reports are sorted using 2-digit numbers. Tell your story clearly.
# A rmarkdown file, sysinfo.Rmd, will be used to produce a report keeping trace of the name and version of R’s package used (with sessionInfo()) and some extra information about the OS (Sys.info()). In an ideal workflow, these commands have to be called at the end of each report.
# Everything lives in a subfolder except run_all.R (detail above).

# One R script to run them all

# Usage

## ```{r setup, include=FALSE}
## knitr::opts_knit$set(root.dir = '../.')
## ```

# Efficient way to deal with packages

#pkgs <- c('reshape2','geojson','readxl','ggplot2',
#          'leaflet','httr','rgeolocate','shiny','sp','dplyr', 'widyr', 
#          'slickR', 'ggraph', 'svglite', 'geojsonio')
#check <- sapply(pkgs,require,warn.conflicts = TRUE,character.only = TRUE)
#if(any(!check)){
  #  pkgs.missing <- pkgs[!check]
  #  install.packages(pkgs.missing)
  #  check <- sapply(pkgs.missing,require,warn.conflicts = TRUE,character.only = TRUE)
  #}

# Limitations
# - Deprecated package functions can be a problem
# - Use packrat?

# Communicating with reporters
# - LINK, DON'T ATTACH
# - Let them browse the data table and download it through there
# - Shiny App can let them play around more
