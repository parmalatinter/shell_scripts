#!/bin/bash
echo "確認したいファイルを入力してください　例：exports/test4/test2.sql";
read file_name;

echo "テスト名を入力してください　例：test";
read test_name;

echo "確認したい開始行番号を入力してください";
read start_line_no;

echo "確認したい終了行番号を入力してください";
read end_line_no;

mkdir "${PWD}/exports/lines"

today=$(date +%Y%m%d-%H%M%S)
export_file_name=${PWD}/exports/lines/${test_name}.${today}_${start_line_no}-${end_line_no}

echo -e "\n"
cat $file_name -n | head -${end_line_no} | tail -`expr ${end_line_no} - ${start_line_no} + 1`
cat $file_name -n | head -${end_line_no} | tail -`expr ${end_line_no} - ${start_line_no} + 1` >> ${export_file_name};
echo -e "\n"

echo "${export_file_name}に書き出しました。";
