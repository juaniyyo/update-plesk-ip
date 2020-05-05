#!/bin/bash
#
# this script update automatically subdomain record from Domain server in Plesk.
#

# Domain parameters
DOMAIN=""
SUB=""
SERVER=""
PORT=""

# Log parameters
LOGFILE="var/log/historicalip.log"

# Today in mm/dd/yyyy format
NOW=$(date +'%m/%d/%Y')

# get external IP
GETEXTIP=$(curl ipecho.net/plain ; echo | awk '{print $6}' | cut -f 1 -d "<")

# get external IP from DNS
GETDNSIP=$(dig +short $NS.$DOMAIN @8.8.8.8)

# DEBUG COMMANDS
#echo "EXT: "$GETEXTIP
#echo "DNS: "$GETDNSIP

# Update DNS entry
if [ "$GETDNSIP" != "$GETEXTIP" ]; 
	then
		echo $NOW "Old IP is: "$GETDNSIP "New IP is: "$GETEXTIP | (tee -a ${LOGFILE})>/dev/null
		ssh $SERVER -p$PORT "/usr/local/psa/bin/dns --del $DOMAIN -a $SUB -ip $GETDNSIP && /usr/local/psa/bin/dns --add $DOMAIN -a $SUB -ip $GETEXTIP" | (tee -a ${LOGFILE})>/dev/null
fi
