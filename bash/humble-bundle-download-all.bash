#!/bin/bash
set -euo pipefail

# Cookie, you can get from your requests
HB_COOKIE=''

# orders , space seprated
HB_ORDERS=''

if [[ -z ${HB_ORDERS:-} ]] || [[ -z ${HB_COOKIE:-} ]];then
	echo "both variable HB_COOKIE and HB_ORDERS must be provided"
	exit 255
fi

for f_order in ${HB_ORDERS};do
	page_json_urls=$(curl --silent --fail --cookie "$HB_COOKIE" "https://www.humblebundle.com/api/v1/order/${f_order}?all_tpkds=true")
	for f_url in $(echo $page_json_urls | jq -r '. ["subproducts"] [] ["downloads"] [] ["download_struct"] [] .url.web ');do
		name=$(echo $f_url|sed 's|.*://[^/]*/\([^?]*\)?.*|\1|g')
                ext=$(echo $name | awk -F"." '{print $NF}')
		if [[ ! -d $ext ]];then 
		       mkdir $ext/	
		fi
		echo "Downloading $f_url in $ext/$name"
		curl --fail --silent "$f_url" -o $ext/$name &
	done
done

