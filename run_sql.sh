nOfParamsNeeded=3

if test $# -lt $nOfParamsNeeded
then
    echo "usage: $0 <user> <db_name> <file.sql>"
    echo "example: $0 postgres progettobasididatidb query.sql"
    exit 1
fi

user=$1
db=$2
filesql=$3

sudo -u $user psql -d $db -a -f $filesql
