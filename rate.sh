#!/bin/bash

# 受け側のURL
url="https://www.gaitameonline.com/rateaj/getrate"

if [ -n "$1"]; then

	ITEM_LIST="GBPNZD CADJPY GBPAUD AUDJPY AUDNZD EURCAD EURUSD NZDJPY USDCAD EURGBP GBPUSD ZARJPY EURCHF CHFJPY AUDUSD USDCHF EURJPY GBPCHF EURNZD NZDUSD USDJPY EURAUD AUDCHF GBPJPY"

	select selection in $ITEM_LIST
	do
	  if [ $selection ]; then
		curl $url | jq-win64.exe ".[] | .[$(($REPLY-1))] | .bid"
	    break
	  else
	    echo "invalid selection."
	  fi
	done
else
	curl $url | jq-win64.exe ".[] | .[$(($1-1))] | .bid"
fi


# while true; do
# 実行

# curl $url | jq-win64.exe ".[] | .[$index] | .bid, .currencyPairCode"

# sleep 60
# done



