#!/bin/sh

. ./curl.config;

rate=""

# 受け側のURL
url="https://www.gaitameonline.com/rateaj/getrate"

if [ $1 ]; then
	rate=$(curl $url | jq-win64.exe ".[] | .[$(($1-1))] | .bid")
else

	if [ $pairNo ]; then

		rate=$(curl $url | jq-win64.exe ".[] | .[$(($pairNo-1))] | .bid")

	else

		ITEM_LIST="GBPNZD CADJPY GBPAUD AUDJPY AUDNZD EURCAD EURUSD NZDJPY USDCAD EURGBP GBPUSD ZARJPY EURCHF CHFJPY AUDUSD USDCHF EURJPY GBPCHF EURNZD NZDUSD USDJPY EURAUD AUDCHF GBPJPY"

		select selection in $ITEM_LIST
		do
		  if [ $REPLY -gt 24 ]; then
			curl $url | jq-win64.exe
		    break
		  elif [ $selection ]; then
			rate=$(curl $url | jq-win64.exe ".[] | .[$(($REPLY-1))] | .bid")
		    break
		  else
		    echo "invalid selection."
		  fi
		done
	fi

fi


rate_float=`echo $rate | bc`

c=`echo "scale=5;((  $entry - $rate_float ) * 10000 )" | bc`

x=`echo "scale=5;((  $entry - $rate_float ) * $amount * $every * $doller )" | bc`

echo "r = $rate_float"
echo "c = $c"
echo "p = $x"

# ($rate * $amount) - ($entry * $amount) 

# while true; do
# 実行

# curl $url | jq-win64.exe ".[] | .[$index] | .bid, .currencyPairCode"

# sleep 60
# done

# 1 - 0.9 * 8500
