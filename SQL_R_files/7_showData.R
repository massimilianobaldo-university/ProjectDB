library(DBI)
library(tidyverse)
#library(ggplot2) #inside tidyverse
library(RPostgreSQL)

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

etichette_asse_x_diagonale <- theme(
    axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)
  )

graphs_path = "./graphs/"

#########################################################

#1) giorni della settimana con più voli

#eseguire prima in postgres il file:
#5_functions.sql (per creare la view conta_numero_voli_per_giorno_settimana)

giornisettimana_volo_count_query = "SELECT * FROM conta_numero_voli_per_giorno_settimana"
giornisettimana_volo_count_df <- dbGetQuery(con, giornisettimana_volo_count_query)

#bar plot con voli per giorni settimana
ggplot(
    data = giornisettimana_volo_count_df, 
    aes(x = giorno_settimana, y = numero_voli, fill = numero_voli)
  ) + 
  geom_bar(stat = "identity") +
  labs(
    title = "Numero di voli per giorno della settimana", 
    x = "Giorno della settimana", 
    y = "Numero di voli"
  ) +
  guides(fill=guide_legend(title="Numero di voli"))

ggsave(
  filename = "1_giorno_settimana_con_piu_voli.png",
  path = graphs_path
  )
################################################################

# #2) numero medio di passeggeri nei voli
# query = "SELECT * FROM posti_rimanenti_info"
# prenotazioni_info <- dbGetQuery(con, query)
# 
# #combine due columns partial keys to one column primary key
# prenotazioni_info$id_istanza <- paste(prenotazioni_info$tratta, prenotazioni_info$data_istanza)
# 
# ggplot(data = prenotazioni_info, aes(x = id_istanza, y = num_posti_prenotati)) + 
#   geom_bar(stat = "identity")
# 
# ggplot(data = prenotazioni_info, aes(x = id_istanza, y = num_posti_prenotati)) +
#   geom_point() + 
#     geom_smooth() #stat = 'smooth', color = 'Red', method = 'gam'


##############################################################################

#2) Percentuale di occupazione degli aerei

percentuale_occupazione_aerei_df_query = "select trunc(perc_occup_aereo, 2) as perc_occupazione_aereo, count(trunc(perc_occup_aereo, 2)) as numero_aerei from posti_rimanenti_info group by perc_occupazione_aereo order by perc_occupazione_aereo;"
percentuale_occupazione_aerei_df <- dbGetQuery(con, percentuale_occupazione_aerei_df_query)

ggplot(
    data = percentuale_occupazione_aerei_df, 
    aes(x = perc_occupazione_aereo, y = numero_aerei)
  ) +
  geom_point() +
  labs(
    title = "Percentuale di occupazione degli aerei", 
    x = "Percentuale occupazione dell'aereo", 
    y = "Numero di aerei"
  )

ggsave(
  filename = "2_percentuale_occupazione_aerei.png",
  path = graphs_path
)
#######################################################################

#3) 

tipi_aeroplano_piu_utilizzati_query <- "select a.tipo_aeroplano, count(*) as numero_tipi from istanzaditratta idt join aeroplano a on a.codice = idt.aeroplano group by tipo_aeroplano order by numero_tipi;"
tipi_aeroplano_piu_utilizzati_df <- dbGetQuery(con, tipi_aeroplano_piu_utilizzati_query)


ggplot(
    data = tipi_aeroplano_piu_utilizzati_df, 
    aes(x = reorder(tipo_aeroplano, -numero_tipi), y = numero_tipi, fill = tipo_aeroplano)
  ) +
  geom_segment( aes(xend=tipo_aeroplano, yend=0)) +
  geom_point( size=4, color="orange") +
  labs(
    title = "Tipologie di aeroplani più utilizzate", 
    x = "Tipo di Aeroplano", 
    y = "Numero di Tipi"
  ) +
  etichette_asse_x_diagonale + 
  guides(fill="none")

#guides(fill=guide_legend(ncol=2)) +

ggsave(
  filename = "3_tipi_aeroplano_piu_utilizzati.png",
  path = graphs_path
)

########################################################################

#4) Le compagnie aeree più economiche


compagnia_aeree_economiche_query = "select trunc(((sum(prezzo))::decimal / ((count(*)/3))), 2) as costo_medio, compagnia_aerea from prezzi_voli_compagnia_aerea group by compagnia_aerea order by costo_medio asc limit 10;"
compagnia_aeree_economiche_df <- dbGetQuery(con, compagnia_aeree_economiche_query)

ggplot(
    data = compagnia_aeree_economiche_df, 
    aes(x = reorder(compagnia_aerea, +costo_medio), y = costo_medio, fill = compagnia_aerea)
  ) +
  geom_bar(stat = "identity") +
  etichette_asse_x_diagonale +
  labs(
    title = "Compagnie aeree più economiche", 
    x = "Compagnia Aerea", 
    y = "Costo Medio"
  ) + 
  guides(fill="none")


ggsave(
  filename = "4_compagnia_aeree_piu_economiche.png",
  path = graphs_path
)

#########################################

#end

dbDisconnect(con)
