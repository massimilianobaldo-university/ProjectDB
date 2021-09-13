file='tipo_aeroplano'
ext='.csv'
i=1

#aggiungere ' come separatore per le stringhe
old_file=${file}${ext}
new_file=${file}'_'${i}${ext}

cat $old_file | sed s:\':'\\'\':g | sed s:';':\"\,\":g >$new_file

i=$(($i + 1))

#ritagliare i campi di interesse
old_file=$new_file
new_file=${file}'_'${i}${ext}

echo '"nome","azienda_costruttrice"' >$new_file
cat $old_file | cut -d',' -f2-3 >>$new_file

i=$(($i + 1))
rm $old_file

mv ${new_file} ${file}_modified${new}${ext}
