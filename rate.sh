#!/bin/bash
index=$1

if [ -n $index ]; then
	$index=$0
else
	echo 'index?'
	read name;
	$index=$name
fi

# https://stedolan.github.io/jq/ jqをインストールする
# 0 "GBPNZD"
# 1 "CADJPY"
# 2 "GBPAUD"
# 3 "AUDJPY"
# 4 "AUDNZD"
# 5 "EURCAD"
# 6 "EURUSD"
# 7 "NZDJPY"
# 8 "USDCAD"
# 9 "EURGBP"
# 10 "GBPUSD"
# 11 "ZARJPY"
# 12 "EURCHF"
# 13 "CHFJPY"
# 14 "AUDUSD"
# 15 "USDCHF"
# 16 "EURJPY"
# 17 "GBPCHF"
# 18 "EURNZD"
# 19 "NZDUSD"
# 20 "USDJPY"
# 21 "EURAUD"
# 22 "AUDCHF"
# 23 "GBPJPY"


# 受け側のURL
url="https://www.gaitameonline.com/rateaj/getrate"

# 実行
curl $url | jq-win64.exe ".[] | .[$index] | .bid, .currencyPairCode"

