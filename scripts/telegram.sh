#!/bin/bash

##########################################################################
# Zabbix-Telegram envio de alerta por Telegram com graficos dos eventos# Date: 25/10/2017
# Original script by Diego Maia - diegosmaia@yahoo.com.br Telegram - @diegosmaia
##########################################################################

MAIN_DIRECTORY="/usr/lib/zabbix/alertscripts"
# To enable the debug set here path of file, otherwise set /dev/null
DEBUG_FILE="/dev/null"

############ Argument to pass to the script and its manipulation
######################################

USER=$1
SUBJECT=$2
DEBUG_SUBJECT=$2
TEXT=$3
DEBUG_TEXT=$3

# Get status and severity from subject

STATUS=$(echo $SUBJECT | awk '{print $1;}')
SEVERITY=$(echo $SUBJECT | awk '{print $2;}')
#STATUS=$(echo $SUBJECT | grep -o -E "(U[0-9A-F]{4}|U[0-9A-F]{3})")
SUBJECT=${SUBJECT#"$STATUS "}
SUBJECT=${SUBJECT#"$SEVERITY "}
SUBJECT="${SUBJECT//,/ }"

# Get graphid from text

GRAPHID=$(echo $TEXT | grep -o -E "(Item Graphic: \[[0-9]{7}\])|(Item Graphic: \[[0-9]{6}\])|(Item Graphic: \[[0-9]{5}\])|(Item Graphic: \[[0-9]{4}\])|(Item Graphic: \[[0-9]{3}\])")
TEXT=${TEXT%"$GRAPHID"}
MESSAGE="${TEXT}"
GRAPHID=$(echo $GRAPHID | grep -o -E "([0-9]{7})|([0-9]{6})|([0-9]{5})|([0-9]{4})|([0-9]{3})")

# Save text to send in file

ZABBIXMSG="/tmp/telegram-zabbix-message-$(date "+%Y.%m.%d-%H.%M.%S").tmp"
echo "$MESSAGE" > $ZABBIXMSG
ZABBIXMSGINPUT=$(<$ZABBIXMSG)

###############
# Zabbix address
#################
ZBX_URL=""

########
# Zabbix credentials to login
############

USERNAME=""PASSWORD=""

#################
# Zabbix versione >= 3.4.1# 0 for no e 1 for yes
##################

ZABBIXVERSION34="1"

##################
# Bot data from Telegram
######################

BOT_TOKEN=''

# If the GRAPHID variable is not compliant not send the graph

case $GRAPHID in ''|*[!0-9]*)
	SEND_GRAPH=0 ;; *)
		SEND_GRAPH=1 ;;esac

		#######
		# To disable graph sending set SEND_GRAPH = 0, otherwise SEND_GRAPH = 1
		# To disable message content sending set SEND_MESSAGE = 0, otherwise SEND_MESSAGE = 1
		#####################

		SEND_GRAPH=0
		SEND_MESSAGE=1

		# If the GRAPHID variable is not compliant, not send the graph

		case $GRAPHID in ''|*[!0-9]*) SEND_GRAPH=0 ;;esac

		########
		# Graph setting
		##############################################

		WIDTH=800
		CURL="/usr/bin/wget"
		COOKIE="/tmp/telegram_cookie-$(date "+%Y.%m.%d-%H.%M.%S")"
		PNG_PATH="/tmp/telegram_graph-$(date "+%Y.%m.%d-%H.%M.%S").png"

		############################################
		# Width of graphs in time (second) Ex: 10800sec/3600sec=3h
		############################################

		PERIOD=10800

		###########################################
		# Check if 3 parameters are passed to script#
		##########################################

		if [ "$#" -lt 3 ]
		then
			echo "$(date "+%Y.%m.%d-%H.%M.%S"):
			ABBRUCH" >> /usr/lib/zabbix/alertscripts/fehler.log exit 1
		fi

			###########################################
			# Convert STATUS and SEVERITY from text to ICON# used https://apps.timwhitlock.info/emoji/tables/unicode to get icon
			# and https://codepoints.net/U+26A0 to get URL-quoted code
			###########################################

			case $STATUS in
				"PROBLEM") ICON="%E2%9A%A0";; #Warning sign
				"OK") ICON="%E2%9C%85";; #Check mark
			       	*) ICON="";;
				esac



				############################################
				# Send messages with SUBJECT and TEXT
				###########################################

				wget "http://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${USER}&text=${ICON} ${SEVERITY} ${SUBJECT}"

				if [ "$SEND_MESSAGE" -eq 1 ]
				then wget "http://api.telegram.org/bot${BOT_TOKEN}/sendMessage?chat_id=${USER}&text=${ZABBIXMSGINPUT}"
				fi

				exit 0
