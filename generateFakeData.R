# RScrpit for generate fake data in csv mode

library(dplyr)
library(tidyverse)
library(fakeR)
library(charlatan)

## First Step: from some real data, create new fake data and aggregate them togheter
## Dataframe to work: cliente, classe_possibile, giorni_della_settimana, compagnia_aerea, tipo_di_aereoplano, aereoporto

dfAereporti <- read.csv("./csv/Aereoporti.csv")
dfTipoAereoplano <- read.csv("./csv/Tipo_Aereplano.csv")
dfGiorniSettimana <- read.csv("./csv/Giorni_della_settimana.csv")
dfClassi <- read.csv("./csv/Classe_Possibile.csv")
dfAereoplani <- read.csv("./csv/Aereoplani.csv")


fakeAereports <- simulate_dataset(dfAereporti, n=80)
fakeAereports <- rbind(dfAereporti, fakeAereports) %>%
  distinct(Airport_code, .keep_all = TRUE)


## Second step
## 

# Dati due vettori di valori unvoci, la funzione crea un df contente un sample del prodotto cartesiano tra i due vettori
generateCartesianProd <- function(n = 1, ...){
  karg <- list(...)
  tmp_df <- cross_df(karg) %>%
            sample_n(n)
  return(tmp_df)
}

#
generateID <- function(n=1, id_format="##") {
  tmpVec = c()
  item = 1
  
  aux <- function(i, id, n, vec) {
    (x <- BaseProvider$new())
    if (i <= n) {
      vec[i] <- x$bothify(id)
      i <- i + 1
      aux(i, id, n, vec)
    } else {
      return(vec)
    }
  }
  
  return(aux(item, id_format, n, tmpVec))
}





# Può decollare
puoDecollare <- generateCartesianProd(50, Airplane_type_name = dfTipoAereoplano$Airplane_type_name,
                                       Airport_code = dfAereporti$Airport_code)

# Tratta
# Tratta ID -> T####
tratta <- generateCartesianProd(50, Aereporto_Arrivo = dfAereporti$Airport_code,
                                Aereporto_Partenza = dfAereporti$Airport_code) %>%
          unique()

tratta$id <- generateID(nrow(tratta), id_format = "T####")
tratta$orario_arrivo <- ch_unix_time(nrow(tratta))
tratta$orario_partenza <- ch_unix_time(nrow(tratta))



# Clienti
clients <- ch_generate('name', 'phone_number', n = 100, locale = "it_IT")
clients$codice_fiscale <- generateID(n=nrow(clients), id_format = "??????##?##???#?")
clients$name <- gsub(pattern = "Sig. |Sig.ra |Dott. ", replacement = "", x = clients$name)
clients <- clients %>% separate("name", c("name","surname"), extra = "merge")


# Classe di Volo
#classeVolo <- generateCartesianProd(50, Classe=dfClassi$Priorita,
                                    #Volo=)

















