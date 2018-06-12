#!/bin/bash
set PWD= $PWD
source ${PWD}/shell.config

echo -n "PG ADMINを閉じてください　*OKの場合なにかキーを押す"
read ok

if [ "$( psql -U postgres -tAc "SELECT 1 FROM pg_database WHERE datname='${master_db}'" )" != '1' ]
then
	psql -U postgres -c "DROP DATABASE IF EXISTS ${master_db}" > log.txt
	psql -U postgres -c "CREATE DATABASE ${master_db}" > log.txt
	echo "データベース${master_db}を作成しました。"
	echo "データベース${master_db}にテーブルとレコードを追加しています......."
	psql -U postgres -d $master_db -f ${PWD}/backup/${master_db}.sql > log.txt
	echo "データベース${master_db}にレコードを更新しています......."
	psql -U postgres -d $master_db -c "update device_infos set device_token='', endpoint='' where user_id != ''" > log.txt
	psql -U postgres -d $master_db -c "UPDATE public.m_users SET password='873aecd8e9d3caff6abb04584f5994b0e64708ef7df9017b10ed71bcf718ba2b'::text WHERE id > 0::integer" > log.txt
	psql -U postgres -d $master_db -f ${PWD}/backup/additional.sql > log.txt
	echo "終了しました。"
fi

psql -U postgres -c "DROP DATABASE IF EXISTS ${new_db}" > log.txt
echo "データベース${master_db}を${new_db}にコピー中。"
createdb -U postgres -T ${master_db} ${new_db} > log.txt
echo "データベース　${new_db}を作成しました。"

psql -U postgres -c "DROP DATABASE IF EXISTS ${old_db}" > log.txt
echo "データベース${master_db}を${old_db}にコピー中。"
createdb -U postgres -T ${master_db} ${old_db} > log.txt
echo "データベース　${old_db}を作成しました。"

cat /dev/null > "C:/Program Files/PostgreSQL/9.3/data/pg_log/refactoring.log"
cat /dev/null > "C:/xampp_2/htdocs/laravel/storage/logs/laravel.log"
echo "データベースとアプリのログをリセットしました。"

echo "終了しました。"