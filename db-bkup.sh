#!/usr/bin/env bash

MYSQL_CONN="-uroot -p${MYSQL_ROOT_PASSWORD}"
BKUPDIR=/storage/backups/dbs
CURR_DATE=$(date +%F)
#
# Collect all database names except for
# mysql, information_schema, and performance_schema
#
SQL="SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN"
SQL="${SQL} ('mysql','information_schema','performance_schema')"

DBLISTFILE=/tmp/DatabasesToDump.txt
mysql ${MYSQL_CONN} -ANe"${SQL}" > ${DBLISTFILE}

MYSQLDUMP_OPTIONS="--routines --triggers --single-transaction"
for DB in `cat ${DBLISTFILE}` ;
    do mysqldump ${MYSQL_CONN} ${MYSQLDUMP_OPTIONS} --databases ${DB} > ${BKUPDIR}/${DB}_${CURR_DATE}.sql; 
done
