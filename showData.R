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
  user = "postgres",
  password = "667l3"
)

#example
#aeroporto <- dbGetQuery(con, "select * from aeroporto;")

#########################################################

#1) giorni della settimana con più voli

#eseguire prima in postgres il file:
#5_functions.sql (per creare la view conta_numero_voli_per_giorno_settimana)

query = "SELECT * FROM conta_numero_voli_per_giorno_settimana"
giornisettimana_volo_count <- dbGetQuery(con, query)

#query = "SELECT * FROM conta_numero_voli_per_giorno_settimana WHERE numero_voli = ( SELECT MAX(numero_voli) FROM conta_numero_voli_per_giorno_settimana )"
#giornisettimana_volo_count_max <- dbGetQuery(con, query)

#bar plot con voli per giorni settimana
ggplot(data = giornisettimana_volo_count, aes(x = giorno_settimana, y = numero_voli)) + 
  geom_bar(stat = "identity")

################################################################

#2) numero medio di passeggeri nei voli
query = "SELECT * FROM posti_rimanenti_info"
prenotazioni_info <- dbGetQuery(con, query)

#combine due columns partial keys to one column primary key
prenotazioni_info$id_istanza <- paste(prenotazioni_info$tratta, prenotazioni_info$data_istanza)

ggplot(data = prenotazioni_info, aes(x = id_istanza, y = num_posti_prenotati)) + 
  geom_bar(stat = "identity")

ggplot(data = prenotazioni_info, aes(x = id_istanza, y = num_posti_prenotati)) +
  geom_point() + 
    geom_smooth() #stat = 'smooth', color = 'Red', method = 'gam'


##############################################################################

#3) 



dbDisconnect(con)
