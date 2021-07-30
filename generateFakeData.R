# RScrpit for generate fake data in csv mode

library(dplyr)
library(tidyverse)
library(hms)
library(charlatan)

## First Step: load the existing data from the directory "./csv"

## These derive from the cleaning of the previous step
aeroporto <- read.csv("./csv/new/aeroporto_modified.csv")
compagniaAerea <- read.csv("./csv/new/compagnia_aerea_modified.csv")
tipoAeroplano <- read.csv("./csv/TipoDiAeroplano.csv")

## These are well known
giornoSettimana <- read.csv("./csv/GiorniDellaSettimana.csv")
classe <- read.csv("./csv/ClassePossibile.csv")


pr <- read.csv("./csv/new/tipo_aeroplano.csv", sep = ";")
pr <- pr[2:3]


# ----------------------------------------------------------------------------- #

## Second step: generate casual data for the necessary analysis

## Auxiliar functions

# Dati due vettori di valori unvoci, la funzione crea un df contente un sample del prodotto cartesiano tra i due vettori
generateCartesianProd <- function(n = 1, ...){
  karg <- list(...)
  tmp_df <- cross_df(karg) %>%
            unique() %>%
            sample_n(n)
  return(tmp_df)
}

# Funzione per creare custom ID secondo un template
# # = è un cifra, ? = è un carattere alfabetico
generateID <- function(n=1, id_format="##") {
  tmpVec = c()
  item = 1
  
  #recursive function for generate a list of different ids
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
  
  # uppercase all the alfa-character
  result <- aux(item, id_format, n, tmpVec) %>%
    lapply(., function(v) {
      if(is.character(v))
        return(toupper(v))
      else
        return(v)
    })
  
  return(result)
}

# Funzione per generare orario nella forma "16:20"
generateTime <- function(n=1, hour=0, minute=23) {
  hours <- as.character(ch_integer(n = n, min = hour, max = 23))
  minutes <- as.character(ch_integer(n = n, min = minute, max = 59))
  return(paste(hours, minutes, sep = ":"))
}

# Funzione per generare orario "sensati" (ovvero che avvegano dopo) dato
# in input un vettore formato da date del tipo "HH:MM"
generateSensibleTime <- function(x=c()) {
  lapply(x, function(v) {
    l <- unlist(str_split(v, ":"))
    t <- generateTime(hour = as.integer(l[1]),
                      minute = as.integer(l[2]))
    return(t)
  }) %>%
    unlist()
}

generateSensibleValue <- function(x=c()) {
  
}


generatePrice <- function(n=1) {
  x <- ch_double(n=n, mean=70, sd = 20)
  unlist(map(x, function(v) {
    if (v < 0)
      return(format(round(abs(v),2), nsmall=2))
    else if (v < 20) {
      v <- v + ch_integer(min = v, max=100)
      return(format(round(v,2), nsmall=2))
    }
    else
      return(format(round(v,2), nsmall=2))
  }))
}


# Tipo di Aeroplano
#tipoAereoplano[1] <- "nome"
#tipoAereoplano[2] <- "azienda_costruttrice"

#tipoAereoplano$numero_massimo_posti <- ch_integer(nrow(tipoAereoplano), min = 50, max = 300)
#tipoAereoplano$autonomia_di_volo <- ch_integer(nrow(tipoAereoplano), min = 3, max = 24)

# Aeroplano
aeroplano <- data.frame(matrix(ncol = 0, nrow = 1000))
aeroplano$codice <- generateID(n = 1000, id_format = "AP###")
aeroplano$tipo_aeroplano <- sample(tipoAeroplano$nome, 1000, replace = TRUE)

l <- map(aeroplano$tipo_aeroplano, function(v) {
  numberRow <- which(tipoAeroplano$nome == v) #tipoAeroplano[which(tipoAeroplano$nome == v), 2]
  maxValue <- tipoAeroplano[numberRow, 2]
  t <- ch_integer(n = 1, min = 20, max = maxValue)
  return(t)
}) %>% unlist()

aeroplano$numero_posti <- l



# Può decollare
puoDecollare <- generateCartesianProd(50, tipo_aeroplano = dfTipoAereoplano$nome,
                                       aeroporto = dfAeroporti$codice)

# Tratta
# Tratta ID -> T####
tratta <- ## load the Tratta dataframe

tratta[1] <- "aereoporto_partenza"
tratta[2] <- "aereoporto_arrivo"
tratta$id <- generateID(nrow(tratta), id_format = "T####")
tratta$orario_partenza <- generateTime(nrow(tratta))
tratta$orario_previsto_arrivo <- generateSensibleTime(tratta$orario_partenza)

# Compagnia Aerea Aereoplano
compagniaAereaAereoplano <- generateCartesianProd(50, compagnia_aerea = dfCompagniaAerea$nome,
                                                  aereoplano = dfAereoplani$codice)



# Clienti
clients <- ch_generate('name', 'phone_number', n = 100, locale = "it_IT")
colnames(clients) <- c("nome","telefono")
clients$nome <- gsub(pattern = "Sig. |Sig.ra |Dott. ", replacement = "", x = clients$nome)
clients$codice_fiscale <- generateID(n=nrow(clients), id_format = "??????##?##???#?")
clients <- clients %>% separate("nome", c("nome","cognome"), extra = "merge")
clients <- clients[, c("codice_fiscale","nome","cognome","telefono")]


# Volo
volo <- generateCartesianProd(50, aeroporto_arrivo=dfAeroporti$codice,
                              aeroporto_partenza=dfAeroporti$codice) %>%
  subset(aeroporto_arrivo != aeroporto_partenza)
volo$codice <- generateID(n = nrow(volo), id_format = "V?###")
volo$orario_partenza <- generateTime(nrow(volo))
volo$orario_previsto_arrivo <- generateSensibleTime(volo$orario_partenza)


# Classe di Volo
classeDiVolo <- generateCartesianProd(30, classe=dfClassi$Priorita,
                                      volo = volo$codice)
classeDiVolo$prezzo <- generatePrice(nrow(classeDiVolo))

#Volo Tratta
voloTratta <- generateCartesianProd(50, tratta=tratta$id,
                                    volo=volo$codice)
#TODO: numero progressivo?


# Prenotazione
prenotazione <- generateCartesianProd(30, cliente=clients$codice_fiscale,
                                      volo = classeDiVolo$volo,
                                      classse = classeDiVolo$classe)
prenotazione$codice <- generateID(nrow(prenotazione), id_format = "P###")








