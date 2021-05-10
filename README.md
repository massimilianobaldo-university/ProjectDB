# ProjectDB
This is the repository for the project of Database.

This is the text about the domain of our poject(written in Italian):

Si voglia modellare il seguente insieme di informazioni riguardanti un sistema di prenotazione dei voli
aerei.

- Ogni aeroporto sia identificato univocamente da un codice e sia caratterizzato da un nome, da una
città e da una nazione. Si assuma che in una data città non vi possano essere due aeroporti con lo
stesso nome (e che ogni città sia identificata univocamente dal nome).
- Ogni tipo di aeroplano sia identificato dal nome e sia caratterizzato dal nome dell’azienda costruttrice,
dal numero massimo di posti a sedere e dall’autonomia di volo.
- Ogni aeroplano sia identificato da un codice e sia caratterizzato dal tipo (di aeroplano) e dal numero
di posti a sedere messi effettivamente a disposizione per i passeggeri. Si assuma che uno stesso
aeroplano possa essere utilizzato da compagnie diverse.
- Per ogni aeroporto, sia definito l’insieme dei tipi di aeroplano che possono decollare/atterrare.
- Ogni volo sia caratterizzato da un codice, che lo identifica univocamente, dalla compagnia aerea che
offre il volo, dai giorni della settimana in cui viene offerto (si assuma che ogni volo sia effettuato al
più una volta in un dato giorno, che gli orari di ogni volo siano sempre gli stessi e che ogni volo, anche
quando costituito da più tratte, inizi e termini nella stessa giornata) e, per ogni classe (business,
economica, ..), dal prezzo del biglietto (si assuma che biglietti di un dato volo relativi alla stessa
classe abbiano tutti lo stesso prezzo).
- Ogni volo sia costituito da un insieme di tratte intermedie (una tratta sia una porzione di volo priva
di scali intermedi), ciascuna identificata da un numero progressivo (prima tratta del volo, seconda
tratta del volo, ..). Ogni tratta sia caratterizzata da un aeroporto di partenza, un aeroporto di
arrivo, un orario previsto di partenza e un orario previsto di arrivo.
- Per ogni specifica istanza di tratta, la data in cui avr`a luogo (ad esempio, la tratta Trieste-Monaco del
25 febbraio 2012), l’aeroplano utilizzato (si assuma che su una stessa tratta possano essere utilizzati
in date diverse aeroplani diversi) e il numero di posti ancora disponibili.
- Ogni prenotazione relativa ad una certa istanza di tratta sia identificata dal posto prenotato (numero pi`u lettera; ad esempio, posto 16D) e sia caratterizzata dal nome, dal cognome e dal recapito
telefonico della persona che ha prenotato il posto.

## TODO

The design should consist of the following steps:

- [ ] Collection and analysis of requirements,
- [ ] Conceptual design,
- [ ] Logical design,
- [ ] Physical design,
- [ ] Implementation,
- [ ] Data analysis in R.

NB: The description of the problem should be enriched, if necessary, in order to include all (or almost all) of the constructs treated during the course.
