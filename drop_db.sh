#!/bin/bash
set PWD= $PWD
source ${PWD}/shell.config

echo -n "PG ADMINを閉じてください　*OKの場合なにかキーを押す";
read ok;

psql -U postgres -c "DROP DATABASE ${new_db}" > log.txt;
psql -U postgres -c "DROP DATABASE ${old_db}" > log.txt;
if [ "$( psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${new_db}'" )" == '1' ]
then
	echo "${new_db}が削除されていません"
fi
if [ "$( psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${old_db}'" )" == '1' ]
then
	echo "${old_db}が削除されていません"
fi
echo "終了しました。";