#!/bin/bash
set PWD= $PWD
source ${PWD}/shell.config
echo -n "m_usersに設定されているカラムの値が存在しないレコードが削除されます。";
echo -n "対象テーブルを指定してください　　　";
read table_name;
echo -n "m_usersのカラム名を指定してください　　　";
read master_column_name;
echo -n "${table_name}のカラム名を指定してください　　　";
read target_column_name;
targets=( $old_db $new_db )
master_table="m_users"
for db in ${targets[@]}; do
	query="DELETE FROM ${table_name} WHERE NOT ${table_name}.${target_column_name} IN (select ${master_column_name} from ${master_table})"
	echo -n "${db} クエリ実行中 : ${query}";
	result=(`psql -U postgres -d $db -c "${query}"`);
	echo -n "終了しました。";
done