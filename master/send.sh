#!/bin/bash

SLAVE_USER='pi' 
SLAVE_PASS='raspberry'

echo "Enter file path to Slave IP's: "
read FILE
echo

echo "Enter file (with path) to send: "
read FILE_NAME
echo 

SLAVE_IPS=`cat $FILE`
for SLAVE_IP in $SLAVE_IPS; do
	sshpass $SLAVE_PASS sftp -oBatchMode=no -b - "${SLAVE_USER}@${SLAVE_IP}" << !
		put "${FILE_NAME}"
		bye
	!
done