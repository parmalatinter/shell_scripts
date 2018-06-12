#!/bin/bash
set PWD= $PWD
source ${PWD}/shell.config
pg_dump -U "postgres" --verbose --file "${PWD}/backup/${master_db}.sql" "${master_db}" > log.txt;
echo -n "終了しました。";