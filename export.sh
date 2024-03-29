#!/bin/bash

function export_diff () {
	arr=$1
	dbname=$2
	set -- "${arr}"
	IFS=","; declare -a lines=($*)
    if [[ ${lines[1]} ]]; then
        start_line_no=$((${lines[0]} - 8))
        end_line_no=$((${lines[1]} + 8))
        echo "@${dbname} line ${lines[0]} ~ ${lines[1]} （前後8行）" >> ${export_file_name};
        echo "########################################## ${dbname} line ${start_line_no} ~ ${end_line_no} start ##########################################" >> ${export_file_name};
        cat ${PWD}/exports/${test_name}/${dbname}.sql -n | head -${end_line_no} | tail -`expr ${end_line_no} - ${start_line_no} + 1` >> ${export_file_name};
        echo "########################################## ${dbname} line ${start_line_no} ~ ${end_line_no} end   ##########################################" >> ${export_file_name};
        echo "" >> ${export_file_name};
        echo "" >> ${export_file_name};
    else
        for line_no in ${lines[@]}; do
            start_line_no=$((${line_no} - 8))
            end_line_no=$((${line_no} + 8))
            echo "@${dbname} line ${line_no} （前後8行）" >> ${export_file_name};
            echo "########################################## ${dbname} line ${start_line_no} ~ ${end_line_no} start ##########################################" >> ${export_file_name};
            cat ${PWD}/exports/${test_name}/${dbname}.sql -n | head -${end_line_no} | tail -`expr ${end_line_no} - ${start_line_no} + 1` >> ${export_file_name};
            echo "########################################## ${dbname} line ${start_line_no} ~ ${end_line_no} end   ##########################################" >> ${export_file_name};
            echo "" >> ${export_file_name};
            echo "" >> ${export_file_name};
        done
	fi
}

echo -n "今回実施したテストの名前を入力してください。";
read test_name;

echo -n "テーブル構造を書き出しますか *必要な場合は1(yes)を押す。"
read is_need_table_structure_num
is_need_table_structure_num=1

set PWD= $PWD
source ${PWD}/shell.config
targets=( $old_db $new_db )
mkdir "${PWD}/exports/"
mkdir "${PWD}/exports/${test_name}"
mkdir "${PWD}/diffs/"
mkdir "${PWD}/diffs/${test_name}"

echo "各データベースをdunmp中......";
for db in ${targets[@]}; do
	pg_dump -U "postgres" --data-only --verbose --file "${PWD}/exports/${test_name}/${db}.sql"  "${db}" > log.txt;
done

echo "diffを書き出し中......";
diff ${PWD}/exports/${test_name}/${old_db}.sql ${PWD}/exports/${test_name}/${new_db}.sql > ${PWD}/diffs/${test_name}/${old_db}_vs_${new_db}.diff

today=$(date +%Y%m%d-%H%M%S)
export_file_name=${PWD}/diffs/${test_name}/${old_db}_vs_${new_db}_result_${today}.diff
cat /dev/null > ${export_file_name}

echo "下記ファイルを比較" >> ${export_file_name};
echo "exports/${test_name}/${old_db}.sql" >> ${export_file_name};
echo "exports/${test_name}/${new_db}.sql" >> ${export_file_name};
echo "" >> ${export_file_name};
echo "" >> ${export_file_name};

set last_line=""
cat ${PWD}/diffs/${test_name}/${old_db}_vs_${new_db}.diff | while read line
do
	if !(grep -q "TOC entry" <<< "$line" || grep -q "Started on" <<< "$line" || grep -q "Completed" <<< "$line" || grep -q "\-\-\-" <<< "$line" || grep -q "\-\- Dependencies: " <<< "$line" || grep -q "\-\- Depen encies: " <<< "$line"); then
		if (grep -q "> " <<< "$line" || grep -q "< " <<< "$line") && !(grep -q "> " <<< "$last_line" || grep -q "< " <<< "$last_line") ; then
			# split実行
			set -- "$last_line"
			IFS="c"; declare -a change_arr=($*)
			if [[ ${change_arr[1]} ]]; then
				echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 変更箇所 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >> ${export_file_name};
	    	echo ${line} >> ${export_file_name}
				echo "-----------------------------------------------------変更（c change）-----------------------------------------------------" >> ${export_file_name};
				export_diff ${change_arr[0]} ${new_db}
				export_diff ${change_arr[1]} ${old_db}
			fi
			IFS="d"; declare -a delete_arr=($*)
			if [[ ${delete_arr[1]} ]]; then
				echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 削除箇所 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >> ${export_file_name};
	    		echo ${line} >> ${export_file_name}
				echo "-----------------------------------------------------削除（d delete）-----------------------------------------------------" >> ${export_file_name};
				export_diff ${delete_arr[0]} ${new_db}
				export_diff ${delete_arr[1]} ${old_db}
			fi
			IFS="a"; declare -a append_arr=($*)
			if [[ ${append_arr[1]} ]]; then
				echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 追加箇所 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" >> ${export_file_name};
	    		echo ${line} >> ${export_file_name}
				echo "-----------------------------------------------------追加（a append）-----------------------------------------------------" >> ${export_file_name};
				export_diff ${append_arr[0]} ${new_db}
				export_diff ${append_arr[1]} ${old_db}
			fi
		fi
	    last_line=${line}
	fi
done

echo "" >> ${export_file_name}
echo "" >> ${export_file_name}

if [ ${is_need_table_structure_num} -eq 1 -o ${is_need_table_structure_num} -eq 2 ]; then
  echo "========================================================== テーブル構造一覧 ==========================================================" >> ${export_file_name}
  for dbname in ${targets[@]}; do
    echo "" >> ${export_file_name};
    echo "～～～～～～～～～～～～～～～～～～ exports/${test_name}/${dbname}.sql ～～～～～～～～～～～～～～～～～～" >> ${export_file_name};
    if [ ${is_need_table_structure_num} -eq 1 ]; then
      grep -n "COPY public." exports/${test_name}/${dbname}.sql  >> ${export_file_name};
    elif [ ${is_need_table_structure_num} -eq 2 ]; then
      grep -n "COPY public." exports/${test_name}/${dbname}.sql | while read -r line;
      do
            set -- "$line"
            IFS=":"; declare -a line_arr=($*)
            start_line_no=${line_arr[0]}
            end_line_no=$((${line_arr[0]} +1))
            cat ${PWD}/exports/${test_name}/${dbname}.sql -n | head -${end_line_no} | tail -`expr ${end_line_no} - ${start_line_no} + 1` >> ${export_file_name};
            echo "" >> ${export_file_name};
      done
    fi
  done
fi

echo "書き出しが終了しました。";

                         