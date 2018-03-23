#!/bin/bash
# folder directory for the raspberry pi should be:
# 
# 		intall 	 -> /home/pi/raspberry-pi-cluster-install
#
# If this is not the case please flash your SD card again.

. /home/pi/raspberry-pi-cluster-install/general/helpers/init-env.sh '/home/pi'

scripts=(init.sh nfs.sh openmpi.sh ssh.sh)
n_elements=${#scripts[@]}

for ((i = 0; i < $n_elements; i ++)); do
	start_script ${scripts[i]}
	. $SHELL_HOME/raspberry-pi-cluster-install/general/${scripts[i]}
	end_script ${scripts[i]}
done

. $SHELL_HOME/raspberry-pi-cluster-install/general/helpers/destroy-env.sh
