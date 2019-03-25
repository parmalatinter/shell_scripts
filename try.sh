#!/bin/sh

. ./curl.config;

rate=""

# 受け側のURL
url="https://ratesapi.io/api/latest?base=TRY"

if [ $1 ]; then
	rate=$(curl $url | jq-win64.exe ".base | .[] | .[$(($1-1))] | .bid")
else

	if [ $pairNo ]; then

		rate=$(curl $url | jq-win64.exe ".rates | .JPY")

	else

		ITEM_LIST="GBPNZD CADJPY GBPAUD AUDJPY AUDNZD EURCAD EURUSD NZDJPY USDCAD EURGBP GBPUSD ZARJPY EURCHF CHFJPY AUDUSD USDCHF EURJPY GBPCHF EURNZD NZDUSD USDJPY EURAUD AUDCHF GBPJPY"

		select selection in $ITEM_LIST
		do
		  if [ $REPLY -gt 24 ]; then
			curl $url | jq-win64.exe
		    break
		  elif [ $selection ]; then
			rate=$(curl $url | jq-win64.exe ".rates | .JPY")
		    break
		  else
		    echo "invalid selection."
		  fi
		done
	fi

fi


rate_float=`echo $rate | bc`

echo $rate
c=`echo "scale=5;((  $rate_float  - 0.56))" | bc`

echo "c = $c"

# ($rate * $amount) - ($entry * $amount) 

# while true; do
# 実行

# curl $url | jq-win64.exe ".base | .[] | .[$index] | .bid, .currencyPairCode"

# sleep 60
# done

# 1 - 0.9 * 8500
