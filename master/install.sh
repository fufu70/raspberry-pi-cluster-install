#!/bin/bash

SLAVE_USER='pi' 
SLAVE_PASS='raspberry'

echo "Enter file path to Slave IP's: "
read -s FILE
echo

SLAVE_IPS=`cat $FILE`
for SLAVE_IP in $SLAVE_IPS; do
	sshpass $SLAVE_PASS ssh "${SLAVE_USER}@${SLAVE_IP}" "git clone https://github.com/fufu70/raspberry-pi-cluster-install"
	sshpass $SLAVE_PASS ssh "${SLAVE_USER}@${SLAVE_IP}" "echo '${SLAVE_PASS}' | sudo bash ./raspberry-pi-cluster-install/general/install.sh"
done