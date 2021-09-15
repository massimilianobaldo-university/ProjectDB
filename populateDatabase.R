library(DBI)
library(tidyverse)
#library(ggplot2) #inside tidyverse
library(RPostgreSQL)
library(dplyr)

# windows command:
# C:\pgsql\bin\psql.exe -h 127.0.0.1 -p 5433 -U postgres -d progettobasididatidb

#change working directory
setwd("csv")
getwd()

drv <- dbDriver("PostgreSQL")

con <- dbConnect(
  drv,
  dbname = "progettobasididatidb",
  host = "127.0.0.1",
  port = 5433, # usually 5432
  user = "postgres",
  password = "######"
)

#not working because of FK dependencies
#files <- list.files(path="./csv", pattern="*.csv", full.names=TRUE, recursive=FALSE)
#lapply(files, function(x) {
#    df <- read.csv(x, header=TRUE) # load file
#    # apply function
#    dbWriteTable(con, name=c("public", tools::file_path_sans_ext(x)))
#})

#start transaction
dbBegin(con)

extension <- "csv"

tables <- c(
  "cliente",
  "prenotazione", 
  "classepossibile", 
  "classedivolo",
  "volo",
  "giornidellasettimana_volo",
  "volo_tratta",
  "giornidellasettimana",
  "compagniaaerea",
  "compagniaaerea_aeroplano",
  "aeroplano",
  "tipodiaeroplano",
  "puodecollare",
  "aeroporto",
  "tratta",
  "istanzaditratta",
  "prenotazione_istanzaditratta"
)

lapply(tables, function(x) {
    file_csv <- paste(x, extension, sep = ".")
    df <- read.csv(file_csv, header=TRUE)
    print(paste("Running: ", x))
    dbWriteTable(con, x, value=df, row.names=FALSE, append=TRUE)
})

#table <- "aeroporto"
#file_csv <- paste(table, extension, sep = ".")
#df <- read.csv(file_csv, header=TRUE)
#dbWriteTable(con, table, value=df, row.names=FALSE, append=TRUE)

#commit transaction
dbCommit(con)

# disconnect from database
dbDisconnect(con)

#go back to original directory
setwd("..")
getwd()
