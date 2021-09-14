# RScript for generate fake data in csv mode

library(tidyverse)
library(charlatan)

set.seed(285391)

## First Step: load the existing data from the directory "./csv"

## These derive from the cleaning of the previous step
# aeroporto <- read.csv("./csv/new/aeroporto_modified.csv", header = FALSE) %>%
#   rename(nome = V1, citta = V2, nazione = V3, codice = V4)

aeroporto <- read.csv("./old_csv/Aeroporti.csv", header = FALSE) %>%
  select(2:5) %>%
  rename(nome = V2, citta = V3, nazione = V4, codice = V5) %>%
  filter(codice != "\\N") %>%
  unique()

write.csv(aeroporto, "./csv/Aeroporto.csv", row.names = FALSE)

# compagniaAerea <- read.csv("./csv/new/compagnia_aerea_modified.csv", header = FALSE) %>%
#   rename(nome = V1)

compagniaAerea <- read.csv("./old_csv/CompagniaAerea.csv", header = FALSE) %>%
  select(2) %>%
  rename(nome = V2) %>%
  unique()
  
write.csv(compagniaAerea, "./csv/CompagniaAerea.csv", row.names = FALSE)

# tratta <- read.csv("./csv/new/tratta_modified.csv", header = FALSE) %>%
#   rename(aeroporto_partenza = V1, aeroporto_arrivo = V2) %>%
#   slice_sample(n = 50)

tratta <- read.csv("./old_csv/Tratta.csv", header = FALSE) %>%
  select(3, 5) %>%
  rename(aeroporto_partenza = V3, aeroporto_arrivo = V5) %>%
  unique() %>%
  slice_sample(n = 50)


## These are well known
tipoDiAeroplano <- read.csv("./csv/TipoDiAeroplano.csv")
giorniDellaSettimana <- read.csv("./csv/GiorniDellaSettimana.csv")
classe <- read.csv("./csv/ClassePossibile.csv")


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

# Funzione per generare degli id sequenziali concreti
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

# Funzione per genrare prezzi in maniera consistente
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
  sample(tipoDiAeroplano$nome, nrow(aeroplano), replace = TRUE)
aeroplano$numero_posti <-
  map(aeroplano$tipo_aeroplano, function(v) {
    numberRow <- which(tipoDiAeroplano$nome == v)
    maxValue <- tipoDiAeroplano[numberRow, 2]
    t <- ch_integer(n = 1, min = 20, max = maxValue)
    return(t)
  }) %>% unlist()
write.csv(aeroplano, "./csv/Aeroplano.csv", row.names = FALSE)

# Può decollare
puoDecollare <- data.frame(matrix(ncol = 0, nrow = 150000))
puoDecollare$tipo_aeroplano <- sample(tipoDiAeroplano$nome, size = nrow(puoDecollare), replace = TRUE)
puoDecollare$aeroporto <- sample(aeroporto$codice, size = nrow(puoDecollare), replace = TRUE)
puoDecollare <- unique(puoDecollare[c("tipo_aeroplano", "aeroporto")])
write.csv(puoDecollare, "./csv/PuoDecollare.csv", row.names = FALSE)

# Tratta
tratta$id <- generateUniqueId(nrow(tratta), prefix = "T")
tratta$orario_previsto_partenza <- generateTime(nrow(tratta))
tratta$orario_previsto_arrivo <- generateSensibleTime(tratta$orario_previsto_partenza)
write.csv(tratta, "./csv/Tratta.csv", row.names = FALSE)

# Compagnia Aerea Aereoplano
compagniaAerea_Aeroplano <- data.frame(matrix(ncol = 0, nrow = 120000))
compagniaAerea_Aeroplano$compagnia_aerea <- sample(compagniaAerea$nome, size = nrow(compagniaAerea_Aeroplano), replace = TRUE)
compagniaAerea_Aeroplano$aeroplano <- sample(aeroplano$codice, size = nrow(compagniaAerea_Aeroplano), replace = TRUE)
compagniaAerea_Aeroplano <- unique(compagniaAerea_Aeroplano[c("compagnia_aerea", "aeroplano")])
write.csv(compagniaAerea_Aeroplano, "./csv/CompagniaAerea_Aeroplano.csv", row.names = FALSE)

# Clienti
cliente <- ch_generate('name', 'phone_number', n = 30000, locale = "it_IT")
colnames(cliente) <- c("nome","telefono")
cliente$nome <- gsub(pattern = "Sig. |Sig.ra |Dott. ", replacement = "", x = cliente$nome)
cliente$codice_fiscale <- generateId(n=nrow(cliente), format = "??????##?##???#?")
cliente <- cliente %>% separate("nome", c("nome","cognome"), extra = "merge")
cliente <- cliente[, c("codice_fiscale","nome","cognome","telefono")]
write.csv(as.matrix(cliente), "./csv/Cliente.csv", row.names = FALSE)

# Volo
volo <- data.frame(matrix(ncol = 0, nrow = 100))
volo$codice <- generateUniqueId(n = nrow(volo), prefix = "V")
volo$compagnia_aerea <- sample(compagniaAerea$nome, size = nrow(volo))
write.csv(volo, "./csv/Volo.csv", row.names = FALSE)

# Giorno Settimana Volo
giorniDellaSettimana_Volo <- data.frame(matrix(ncol = 0, nrow = 200))
giorniDellaSettimana_Volo$giorno_settimana <- sample(giorniDellaSettimana$nome, size = nrow(giorniDellaSettimana_Volo), replace = TRUE)
giorniDellaSettimana_Volo$volo <- sample(volo$codice, size = nrow(giorniDellaSettimana_Volo), replace = TRUE)
giorniDellaSettimana_Volo <- unique(giorniDellaSettimana_Volo[c("giorno_settimana", "volo")])
write.csv(giorniDellaSettimana_Volo, "./csv/GiornidellaSettimana_Volo.csv", row.names = FALSE)

# Classe di Volo
# Prodotto cartesiano tra i due dataframe
classeDiVolo <- expand.grid(classe = classe$priorita, volo = volo$codice)
classeDiVolo <- unique(classeDiVolo[c("classe", "volo")])
classeDiVolo$prezzo <- generatePrice(nrow(classeDiVolo))
write.csv(classeDiVolo, "./csv/ClasseDiVolo.csv", row.names = FALSE)

#Volo Tratta
voloTratta1 <- data.frame(matrix(ncol = 0, nrow = 50))
voloTratta1$volo <- sample(volo$codice, size = nrow(voloTratta1))
voloTratta1$tratta <- sample(tratta$id, size = nrow(voloTratta1))
voloTratta1$numero_progressivo <- rep(1)

voloTratta2 <- anti_join(volo, voloTratta1, by = c("codice" = "volo")) %>% subset(select = -c(compagnia_aerea))
voloTratta2$tratta <- sample(tratta$id, size = nrow(voloTratta2))
voloTratta2$numero_progressivo <- rep(1)

## Trovo delle tratte per le quali l'aeroporto di arrivo è anche aereoporto di partenza
secondaTratta <- inner_join(voloTratta2, tratta, by = c("tratta" = "id")) %>%
  inner_join(tratta, by = c("aeroporto_arrivo" = "aeroporto_partenza")) %>%
  select(codice, id, numero_progressivo) %>%
  unique()

colnames(voloTratta2) <- c("volo", "tratta", "numero_progressivo")
colnames(secondaTratta) <- c("volo", "tratta", "numero_progressivo")

secondaTratta$numero_progressivo <- secondaTratta$numero_progressivo + 1

voloTratta <- rbind(voloTratta1, voloTratta2, secondaTratta)

remove(voloTratta1, voloTratta2, secondaTratta)
write.csv(voloTratta, "./csv/Volo_Tratta.csv", row.names = FALSE)

# Prenotazione
prenotazione <- data.frame(matrix(ncol = 0, nrow = 1000000))
prenotazione$cliente <- sample(cliente$codice_fiscale, size = nrow(prenotazione), replace = TRUE)
prenotazione$volo <- sample(classeDiVolo$volo, size = nrow(prenotazione), replace = TRUE)
prenotazione$classe <- sample(classeDiVolo$classe, size = nrow(prenotazione), replace = TRUE)
prenotazione$codice <- generateUniqueId(nrow(prenotazione), prefix = "P")
write.csv(as.matrix(prenotazione), "./csv/Prenotazione.csv", row.names = FALSE)

# Istanza di Tratta
istanzaDiTratta <- data.frame(matrix(ncol = 0, nrow = 160000))
istanzaDiTratta$tratta <- sample(tratta$id, size = nrow(istanzaDiTratta), replace = TRUE)
istanzaDiTratta$data_istanza <- sample(seq(as.Date('1990/01/01'), as.Date('2021/01/01'), by="day"), size = nrow(istanzaDiTratta), replace = TRUE)
istanzaDiTratta <- unique(istanzaDiTratta[c("tratta", "data_istanza")])
istanzaDiTratta$aeroplano <- sample(aeroplano$codice, size = nrow(istanzaDiTratta), replace = TRUE)
istanzaDiTratta$numero_posti_rimanenti <- 
  inner_join(istanzaDiTratta, aeroplano, by = c("aeroplano" = "codice")) %>%
  .$numero_posti %>%
  map(~ sample(x = (1:.), size = 1)) %>%
  unlist()
write.csv(mutate(istanzaDiTratta, data_istanza=as.character(data_istanza)), "./csv/IstanzaDiTratta.csv", row.names = FALSE)

remove(compagniaAerea_Aeroplano, puoDecollare, cliente, aeroporto)

# Prenotazione istanza di tratta
# Si estrapolano le righe in modo che siano consistenti i valori estraplati
prenotazione_IstanzaDiTratta <-
  istanzaDiTratta[sample(row.names(istanzaDiTratta), 1500000, replace = TRUE), c("tratta", "data_istanza")]
prenotazione_IstanzaDiTratta$codice_prenotazione <-
  sample(
    prenotazione$codice,
    size = nrow(prenotazione_IstanzaDiTratta),
    replace = TRUE
  )
prenotazione_IstanzaDiTratta$posto_prenotato <-
  inner_join(prenotazione_IstanzaDiTratta,
             istanzaDiTratta,
             by = c("tratta" = "tratta", "data_istanza" = "data_istanza")) %>%
  select(aeroplano) %>%
  inner_join(aeroplano, by = c("aeroplano" = "codice")) %>%
  select(numero_posti) %>%
  unlist() %>%
  lapply(., function(v) {
    v <- sample((1:v), size = 1)
  })
colnames(prenotazione_IstanzaDiTratta)[2] <- "data_istanza_tratta"
       
write.csv(prenotazione_IstanzaDiTratta %>%
            mutate(data_istanza_tratta = as.character(data_istanza_tratta)) %>%
            as.matrix(), "./csv/Prenotazione_IstanzaDiTratta.csv", row.names = FALSE)
