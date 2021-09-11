library(DBI)
library(tidyverse)
#library(ggplot2) #inside tidyverse
library(RPostgreSQL)
library(dplyr)

# windows command:
# C:\pgsql\bin\psql.exe -h 127.0.0.1 -p 5433 -U postgres -d progettobasididatidb

setwd("csv")

drv <- dbDriver("PostgreSQL")

con <- dbConnect(
  drv,
  dbname = "progettobasididatidb",
  host = "127.0.0.1",
  port = 5433, # usually 5432
  user = "postgres",
  password = "667l3"
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
    "Cliente", 
    "Prenotazione", 
    "ClassePossibile", 
    "ClasseDiVolo",
    "Volo",
    "GiorniDellaSettimana_Volo",
    "Volo_Tratta",
    "GiorniDellaSettimana",
    "CompagniaAerea",
    "CompagniaAerea_Aeroplano",
    "Aeroplano",
    "TipoDiAeroplano",
    "PuoDecollare",
    "Aeroporto",
    "Tratta",
    "IstanzaDiTratta",
    "Prenotazione_IstanzaDiTratta"
)

lapply(tables, function(x) {
    df <- read.csv(paste(x, extension, sep = "."), header=TRUE)
    dbWriteTable(con, name=c("public", x), value=df, 
                 row.names=FALSE, overwrite=TRUE)
})

#df <- read.csv(paste("cliente", extension, sep = "."), header=TRUE)
#dbWriteTable(con, "cliente", value=df, row.names=FALSE, overwrite=TRUE)

#commit transaction
dbCommit(con)

# disconnect from database
dbDisconnect(con)
