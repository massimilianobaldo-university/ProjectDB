nOfParamsNeeded=1
nOfParamsOptionals=2

user='postgres'
db='progettobasididatidb'

if test $# -lt $nOfParamsNeeded
then
    echo "usage: $0 <file.sql> [<user>=$user] [<db_name>=$db]"
    echo "example: $0 query.sql"
    echo "example: $0 query.sql $user $db"
    echo "example: $0 query.sql $user postgres (NB per creare/distruggere un db='x' connettersi con db='postgres')"
    exit 1
fi

filesql=$1
shift

if test $# -ge $nOfParamsOptionals
then
    user=$1
    db=$2
fi

sudo -u $user psql -d $db -a -f $filesql
