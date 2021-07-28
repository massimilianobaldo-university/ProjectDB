file='tipo_aeroplano_new'
ext='.csv'
i=1

#agggiungere ' come separatore per le stringhe
old_file=${file}${ext}
new_file=${file}'_'${i}${ext}

cat $old_file | sed s:\':'\\'\':g | sed s:';':\'\;\':g >$new_file

i=$(($i + 1))

#ritagliare i campi di interesse
old_file=$new_file
new_file=${file}'_'${i}${ext}

cat $old_file | cut -d';' -f2-3 >$new_file

i=$(($i + 1))

#usare , come separatore e non ;
old_file=$new_file
new_file=${file}'_'${i}${ext}

cat $old_file | sed s:';':',':g >$new_file

i=$(($i + 1))
