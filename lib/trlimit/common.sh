#!/bin/sh

[ -n "$TRLIMIT_COMMON" ] && return || readonly TRLIMIT_COMMON=1

. /lib/functions.sh

CONFIG_FILE="trlimit"
CONFIG_FILE_FULL="/etc/config/trlimit"
QOS_CONFIG_FILE="/etc/config/qos"
QOS_CONFIG_FOLDER="/etc/config/"
QOS_BACKUP_FOLDER="/etc/trlimit/"
QOS_BACKUP_FILE="/etc/trlimit/qos"
MAIL_SENT_FOLDER="/etc/trlimit/sent/"
OVERWRITTEN_STR="trlimit_overwrite"

log() {
	logger -t trlimit -p "$1" "$2"
}
startQOS() {
	sh "/etc/init.d/qos" "start"
}
stopQOS() {
	sh "/etc/init.d/qos" "stop"
}



