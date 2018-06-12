#!/bin/bash
echo "環境を選択してください 1(cake) or 2(laravel)";
read environment_num;

if [ ${environment_num} -eq 1 ]; then
	tail -f "C:/xampp_1/htdocs/gitrits/src/app/tmp/logs/error.log"
fi

if [ ${environment_num} -eq 2 ]; then
	tail -f "C:/xampp_2/htdocs/laravel/storage/logs/laravel.log"
fi