file='Aeroport.csv'

#usare ' al posto di " per le stringhe
old_file='./old_csv/'$file
new_file='./csv/'$file

cat $old_file | sed s:\':'\\'\':g | sed s:\":\':g > $old_file

#ritagliare i campi di interesse

cat $old_file | cut -d',' -f2-5 > $old_file

#rimuovere le righe che hanno ',' nel nome.. abbiamo perso il codice

cat $old_file | grep [A-Z][A-Z][A-Z]\'$ >$new_file