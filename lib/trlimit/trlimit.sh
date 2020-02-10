#!/bin/sh
. /lib/trlimit/common.sh


setTrafficLimit() {
	local interfaceNick="$1"
	local upload_limit="$2"
	local download_limit="$3"
	local enabled="$4"
	
	local returnType
	returnType="$(uci -q get qos."$interfaceNick")"
	local error="$?"
	
	if [ "$error" = 0 ] 
	then
		if [ "$returnType" = "interface" ]	#interfaceNick already exists
		then
			stopQos
			uci set qos."$interfaceNick".upload="$UPLOAD"
			uci set qos."$interfaceNick".download="$DOWNLOAD"
			uci set qos."$interfaceNick".enabled="$enabled"
			uci set qos."$OVERWRITTEN_STR"='1'
			uci commit qos
			startQos
		else
			echo "ERROR: $interfaceNick is no interface. It is a $returnType"
			exit 1
		fi
	elif [ "$error" = 1 ]	#Entry not found
	then
		stopQos
		uci set qos."$interfaceNick"=interface
		uci set qos."$interfaceNick".upload="$upload_limit"
		uci set qos."$interfaceNick".download="$download_limit"
		uci set qos."$interfaceNick".enabled="$enabled"
		uci set qos."$OVERWRITTEN_STR"='1'
		uci commit qos
		startQos
	elif [ "$error" -gt 1 ]
	then
		echo "ERROR: uci returned $error"
		exit 1
	fi
}

checkIfAlreadyLimited() {
	local interfaceNick="$1"
	local limited
	limited=$(uci -q get qos."$interfaceNick".enabled)
	local error="$?"
	if [ "$error" = 0 ]
	then
		if [ "$limited" != 0 ]
		then
		        echo 1
		else
		        echo 0
		fi
	else
		echo 0
	fi
	
}

setAllLimitsToOff() {
	config_load "$CONFIG_FILE"
	config_foreach stopLimitInterface interfaceLimit
}
stopLimitInterface() {
	local interfaceLimit="$1"
	local interfaceNick
	local enabled
	local upload_limit
	local download_limit
	config_load "$CONFIG_FILE"
	config_get interfaceNick "$interfaceLimit" "interfaceNick"
	config_get_bool enabled "$interfaceLimit" "enabled"
	config_get upload_limit "$interfaceLimit" "upload_limit"
	config_get download_limit "$interfaceLimit" "download_limit"
	
	if [ "$enabled" != 0 ]
	then
		setTrafficLimit "$interfaceNick" "$upload_limit" "$download_limit" 0
	fi
}


