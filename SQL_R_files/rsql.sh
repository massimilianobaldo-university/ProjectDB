#!/bin/bash
# ---------------------------------------------------------------------------
# rsql - Bash shell script for run sql files in a Postgres database
# Usage: rsql [[-h|--help]
#        rsql [-u|--user] [-d|--databse] [query.sql]]
# ---------------------------------------------------------------------------

user='postgres'
db='progettobasididatidb'
port=5432

# Parse command line
while [[ -n $1 ]]; do
  case $1 in
    -h | --help)
      echo "rsql - Bash shell script for run sql files in a Postgres database";
      echo -e "Usage:\trsql [[-h|--help]";
      echo -e "\trsql [-u|--user] [-d|--databse] [query.sql]]";
      exit 1;
      ;;
    -u | --user)
      user=$2;
      shift;
      ;;
    -d | --databse)
      db=$2;
      shift;
      ;;
    -p | --port)
      port=$2;
      shift;
      ;;
    -* | --*)
      echo Unknow flas;
      ;;
    *)
      fileSQL=$1; break
      ;;
  esac
  shift
done


if [[ $user != 'postgres' || $db != 'progettobasididatidb' ]]; then
    psql -U $user -d $db -p $port -a -f $fileSQL
else 
    psql -U $user -a -f $fileSQL
fi