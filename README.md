Overview

## 推奨Postgresバージョン

PostgreSQL Download
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads

PgAdmin3
https://www.pgadmin.org/download/pgadmin-3-windows/

## 設定ファイル
shell.config

master_db=コピー元DB名
old_db=旧アプリ用DB名
new_db=新アプリ用DB名

## DB(コピー元)ダンプ
master_dump.sh

## DB初期化
reset.sh

## DB出力&差分出力
export.sh

## new_dbからold_dbへのコピー
db_sync_new_to_old.sh

## old_dbからnew_dbへのコピー
db_sync_old_to_new.sh

## 指定ファイルから指定行を表示して書き出す
file_line_view.sh

## m_usersに設定されているカラムの値が存在しないレコードを削除
clean_table_by_user_id.sh