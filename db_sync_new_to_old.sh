#!/bin/bash
set PWD= $PWD
source ${PWD}/shell.config

targets=( $old_db $new_db )

echo -n "PG ADMINを閉じてください　*OKの場合なにかキーを押す";
read ok;

psql -U postgres -d ${new_db} -c "UPDATE public.m_users SET password='873aecd8e9d3caff6abb04584f5994b0e64708ef7df9017b10ed71bcf718ba2b'::text WHERE id > 0::integer" > log.txt;
psql -U postgres -d ${new_db} -c "update device_infos set device_token='', endpoint='' where user_id != ''" > log.txt;
psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid <> pg_backend_pid() AND datname = '${old_db}'" > log.txt;
psql -U postgres -c "DROP DATABASE IF EXISTS ${old_db}" > log.txt;
echo -n "DB作成中..........";
createdb -U postgres -T ${new_db} ${old_db} > log.txt;
echo -n "データベース　${old_db}を作成しました。";

cat /dev/null > "C:/Program Files/PostgreSQL/9.3/data/pg_log/refactoring.log"
cat /dev/null > "C:/xampp_2/htdocs/laravel/storage/logs/laravel.log"
echo "データベースとアプリのログをリセットしました。"


echo -n "終了しました。";