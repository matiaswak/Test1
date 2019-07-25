options(repos = 'https://cran.rstudio.com/')

if(suppressMessages(suppressWarnings(!require(digest)))){install.packages("digest");library(digest)}
if(suppressMessages(suppressWarnings(!require(flexdashboard)))){install.packages("flexdashboard");library(flexdashboard)}
if(suppressMessages(suppressWarnings(!require(shinydashboard)))){install.packages("shinydashboard");library(shinydashboard)}
if(suppressMessages(suppressWarnings(!require(shinyjs)))){install.packages("shinyjs");library(shinyjs)}
if(suppressMessages(suppressWarnings(!require(tidyverse)))){install.packages("tidyverse");library(tidyverse)}
if(suppressMessages(suppressWarnings(!require(shinyalert)))){install.packages("shinyalert");library(shinyalert)}
