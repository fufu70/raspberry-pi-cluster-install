#!/bin/bash

# update the machine
sudo apt-get -y --force-yes update

# Update and install essential 
sudo apt-get -y --force-yes install build-essential manpages-dev 

#install vim ... cause why not
sudo apt -y --force-yes install vim nmap

#install git for getting necessary packages
sudo apt -y --force-yes install git 

# Install quick bash scripts
git clone git://github.com/fufu70/quick-bash-scripts.git
bash ./quick-bash-scripts/install-local.sh
