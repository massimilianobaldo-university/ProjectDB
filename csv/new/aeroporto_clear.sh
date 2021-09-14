file='aeroporto'
ext='.csv'
i=1

#usare ' al posto di " per le stringhe
old_file=${file}${ext}
new_file=${file}'_'${i}${ext}

cat $old_file | sed s:\':'\\'\':g >$new_file

i=$(($i + 1))

#ritagliare i campi di interesse
old_file=$new_file
new_file=${file}'_'${i}${ext}

cat $old_file | cut -d',' -f2-5 >$new_file

i=$(($i + 1))
rm $old_file

#rimuovere le righe che non terminano con un codice [A-Z]{3,3}
old_file=$new_file
new_file=${file}'_'${i}${ext}

echo '"nome","citta","nazione","codice"' >$new_file
cat $old_file | grep \"[A-Z][A-Z][A-Z]\"$ >>$new_file

i=$(($i + 1))
rm $old_file

mv ${new_file} ${file}_modified${new}${ext}