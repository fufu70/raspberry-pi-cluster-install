#!/bin/bash

# update the machine
sudo apt -y --force-yes update

# Update and install essential 
sudo apt-get -y --force-yes install build-essential manpages-dev 

#install vim ... cause why not
sudo apt -y --force-yes install vim nmap

#install git for getting necessary packages
sudo apt -y --force-yes install git 

# Install quick bash scripts