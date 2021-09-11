# RScrpit for generate fake data in csv mode

library(tidyverse)
library(charlatan)

set.seed(285391)

## First Step: load the existing data from the directory "./csv"

## These derive from the cleaning of the previous step
aeroporto <- read.csv("./csv/new/aeroporto_modified.csv", header = FALSE) %>%
  rename(nome = V1, citta = V2, nazione = V3, codice = V4)

compagniaAerea <- read.csv("./csv/new/compagnia_aerea_modified.csv", header = FALSE) %>%
  rename(nome = V1)

tratta <- read.csv("./csv/new/tratta_modified.csv", header = FALSE) %>%
  rename(aeroporto_partenza = V1, aeroporto_arrivo = V2) %>%
  slice_sample(n = 50)

tipoAeroplano <- read.csv("./csv/TipoDiAeroplano.csv")

## These are well known
giornoSettimana <- read.csv("./csv/GiorniDellaSettimana.csv")
classe <- read.csv("./csv/ClassePossibile.csv")


#pr <- read.csv("./csv/new/tipo_aeroplano.csv", sep = ";")
#pr <- pr[2:3]


# ----------------------------------------------------------------------------- #

## Second step: generate casual data for the necessary analysis

## Auxiliar functions

# Funzione per creare custom ID secondo un template
# # = è un cifra, ? = è un carattere alfabetico
generateId <- function(n=1, format="##") {
  (x <- BaseProvider$new())
  tmpVec = character(n)
  
  # substitute new Id for all the elements and
  # uppercase all the alfa-character
  result <- lapply(tmpVec, function(v) {
      v <- x$bothify(format)
      if(is.character(v))
        v <- toupper(v)
      return(v)
    })
  
  return(result)
}

generateUniqueId <- function(n=1, prefix="") {
  v <- (1:n) %>%
    lapply(., function(e) {
      return(paste(prefix, e, sep = ""))
    }) %>% unlist()
  return(v)
}


# Funzione per generare orario nella forma "HH:MM"
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

# Aeroplano
aeroplano <- data.frame(matrix(ncol = 0, nrow = 1000))
aeroplano$codice <- generateUniqueId(n = nrow(aeroplano), prefix = "AP")
aeroplano$tipo_aeroplano <-
  sample(tipoAeroplano$nome, nrow(aeroplano), replace = TRUE)
aeroplano$numero_posti <-
  map(aeroplano$tipo_aeroplano, function(v) {
    numberRow <- which(tipoAeroplano$nome == v)
    maxValue <- tipoAeroplano[numberRow, 2]
    t <- ch_integer(n = 1, min = 20, max = maxValue)
    return(t)
  }) %>% unlist()
write.csv(aeroplano, "./csv/Aeroplano.csv")

# Può decollare
puoDecollare <- data.frame(matrix(ncol = 0, nrow = 150000))
puoDecollare$tipo_aeroplano <- sample(tipoAeroplano$nome, size = nrow(puoDecollare), replace = TRUE)
puoDecollare$aeroporto <- sample(aeroporto$codice, size = nrow(puoDecollare), replace = TRUE)
write.csv(puoDecollare, "./csv/PuòDecollare.csv")

# Tratta
tratta$id <- generateUniqueId(nrow(tratta), prefix = "T")
tratta$orario_partenza <- generateTime(nrow(tratta))
tratta$orario_previsto_arrivo <- generateSensibleTime(tratta$orario_partenza)
write.csv(tratta, "./csv/Tratta.csv")

# Compagnia Aerea Aereoplano
compagniaAereaAereoplano <- data.frame(matrix(ncol = 0, nrow = 120000))
compagniaAereaAereoplano$compagnia_aerea <- sample(compagniaAerea$nome, size = nrow(compagniaAereaAereoplano), replace = TRUE)
compagniaAereaAereoplano$aeroplano <- sample(aeroplano$codice, size = nrow(compagniaAereaAereoplano), replace = TRUE)
write.csv(compagniaAereaAereoplano, "./csv/CompagniaAereaAereoplano.csv")

# Clienti
cliente <- ch_generate('name', 'phone_number', n = 200)
#cliente$nome <- ch_name(n = 600000)
colnames(cliente) <- c("nome","telefono")
cliente$nome <- gsub(pattern = "Sig. |Sig.ra |Dott. ", replacement = "", x = cliente$nome)
cliente$codice_fiscale <- generateId(n=nrow(cliente), format = "??????##?##???#?")
cliente <- cliente %>% separate("nome", c("nome","cognome"), extra = "merge")
cliente <- cliente[, c("codice_fiscale","nome","cognome","telefono")]
write.csv(cliente, "./csv/Cliente.csv")

# Volo
volo <- data.frame(matrix(ncol = 0, nrow = 100))
# volo$aeroporto_arrivo <- sample(aeroporto$codice, size = nrow(volo))
# volo$aeroporto_partenza <- sample(aeroporto$codice, size = nrow(volo))
# volo <- volo %>% subset(aeroporto_arrivo != aeroporto_partenza)
volo$codice <- generateUniqueId(n = nrow(volo), prefix = "V")
# volo$orario_partenza <- generateTime(nrow(volo))
# volo$orario_previsto_arrivo <- generateSensibleTime(volo$orario_partenza)
write.csv(volo, "./csv/Volo.csv")

# Giorno Settimana Volo
giorniSettimanaVolo <- data.frame(matrix(ncol = 0, nrow = 200))
giorniSettimanaVolo$giorno <- sample(giornoSettimana$nome, size = nrow(giorniSettimanaVolo), replace = TRUE)
giorniSettimanaVolo$volo <- sample(volo$codice, size = nrow(giorniSettimanaVolo), replace = TRUE)

# Classe di Volo
# classeDiVolo <- data.frame(matrix(ncol = 0, nrow = ))
classeDiVolo <- expand.grid(classe = classe$Priorita, volo = volo$codice)
# classeDiVolo$classe <- sample(classe$Priorita, size = nrow(classeDiVolo), replace = TRUE)
# classeDiVolo$volo <- sample(volo$codice, size = nrow(classeDiVolo), replace = TRUE)
classeDiVolo$prezzo <- generatePrice(nrow(classeDiVolo))
write.csv(classeDiVolo, "./csv/ClasseDiVolo.csv")

#Volo Tratta
voloTratta <- data.frame(matrix(ncol = 0, nrow = 150))
voloTratta$tratta <- sample(tratta$id, size = nrow(voloTratta), replace = TRUE)
voloTratta$volo <- sample(volo$codice, size = nrow(voloTratta), replace = TRUE)
voloTratta$numero_progressivo <- rep(1)

## Trovo delle tratte per le quali l'aeroporto di arrivo è anche aereoporto di destinazione
secondaTratta <- inner_join(voloTratta, tratta, by = c("tratta" = "id")) %>% 
  subset(aeroporto_arrivo %in% aeroporto_partenza)

## A quelle specifiche tratte, assegno un valore progressivo maggiore
voloTratta$numero_progressivo[voloTratta$tratta %in% secondaTratta$id] <- voloTratta$numero_progressivo[voloTratta$tratta %in% secondaTratta$id] + 1

remove(secondaTratta)
write.csv(voloTratta, "./csv/VoloTratta.csv")

# Prenotazione
prenotazione <- data.frame(matrix(ncol = 0, nrow = 6000))
prenotazione$cliente <- sample(cliente$codice_fiscale, size = nrow(prenotazione), replace = TRUE)
prenotazione$volo <- sample(classeDiVolo$volo, size = nrow(prenotazione), replace = TRUE)
prenotazione$classe <- sample(classeDiVolo$classe, size = nrow(prenotazione), replace = TRUE)
prenotazione$codice <- generateUniqueId(nrow(prenotazione), prefix = "P")
write.csv(as.matrix(prenotazione), "./csv/Prenotazione.csv")

# Istanza di Tratta
istanzaTratta <- data.frame(matrix(ncol = 0, nrow = 136875))
istanzaTratta$tratta <- sample(tratta$id, size = nrow(istanzaTratta), replace = TRUE)
istanzaTratta$aeroplano <- sample(aeroplano$codice, size = nrow(istanzaTratta), replace = TRUE)
istanzaTratta$data <- sample(seq(as.Date('1990/01/01'), as.Date('2021/01/01'), by="day"), size = nrow(istanzaTratta), replace = TRUE)
istanzaTratta$numero_posti_rimanenti <- 
  inner_join(istanzaTratta, aeroplano, by = c("aeroplano" = "codice")) %>%
  .$numero_posti %>%
  map(~ sample(x = (1:.), size = 1)) %>%
  unlist()
write.csv(istanzaTratta, "./csv/IstanzaTratta.csv")

remove(compagniaAereaAereoplano, puoDecollare, cliente, aeroporto)

# Prenotazione istanza di tratta
# codice_prenotazione, tratta, data_istanza_tratta, posto_prenotato
# prenotazioneIstanzaTratta <- data.frame(matrix(ncol = 0, nrow = 10000))
prenotazioneIstanzaTratta <- istanzaTratta[which(row.names(istanzaTratta) %in% sample(row.names(istanzaTratta), 10000)), c("tratta", "data")]
prenotazioneIstanzaTratta$codice_prenotazione <- sample(prenotazione$codice, size = nrow(prenotazioneIstanzaTratta), replace = TRUE)
prenotazioneIstanzaTratta$tratta <- sample(istanzaTratta$tratta, size = nrow(prenotazioneIstanzaTratta))
prenotazioneIstanzaTratta$data_istanza_tratta <- inner_join(prenotazioneIstanzaTratta, istanzaTratta) %>%
  select(data)
# prenotazioneIstanzaTratta$posto_prenotato
p <- inner_join(prenotazioneIstanzaTratta, istanzaTratta, by=c("tratta"="tratta", "data_istanza_tratta"="data"))
  # select(aeroplano) %>%
  # inner_join(aeroplano, by = c("aeroplano" = "codice")) %>%
  # select(numero_posti) 

# %>%
#   unlist() %>%
#   lapply(., function(v) {
#     v <- sample((1:v), size=1)
#   })
       
write.csv(prenotazioneIstanzaTratta, "./csv/PrenotazioneIstanzaTratta.csv")
