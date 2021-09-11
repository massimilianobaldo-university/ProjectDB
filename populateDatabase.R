library(DBI)
library(tidyverse)
#library(ggplot2) #inside tidyverse
library(RPostgreSQL)
library(dplyr)

# windows command:
# C:\pgsql\bin\psql.exe -h 127.0.0.1 -p 5433 -U postgres -d progettobasididatidb

drv <- dbDriver("PostgreSQL")

con <- dbConnect(
  drv,
  dbname = "progettobasididatidb",
  host = "127.0.0.1",
  port = 5433, # usually 5432
  user = "noob",
  password = "in_chiaro"
)

