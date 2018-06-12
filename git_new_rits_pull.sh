cd C:/xampp_2/htdocs/laravel

echo -n "今回PULLしたいブランチ名を入力してください。";
read branch_name;
current_branch_name=`git symbolic-ref --short HEAD`

 git prune

if [ ! "$current_branch_name" = "${branch_name}" ]; then
	git add ./
	git stash save "temporary"
else
	echo "${current_branch_name}の変更ファイルをstashしますか？ yes(1) : no(1以外)"
	read queston;
	if [ $queston -eq 1 ]; then
		git add ./
		git stash save "temporary"
	else
		echo -n "変更ファイルが存在していたため終了しました。"
		exit
	fi
fi

git checkout master
exists=`git rev-parse --verify --quiet ${branch_name}`
if [ -n "$exists" ]; then
   git branch -D ${branch_name}
fi
git checkout ${branch_name}

if [ ! "$current_branch_name" = "${branch_name}" ]; then
	git stash pop stash@{0}
fi

echo -n "ライブラリを最新にしてviewファイルをcompileしています。"

composer install
npm install
npm run dev

php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear