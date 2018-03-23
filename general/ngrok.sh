#!/bin/bash
# Based off of Nicola Malizia's Ngrok installation tutorial
#
# @link https://medium.com/@unnikked/how-to-compile-ngrok-on-a-raspberry-pi-d5a78ce4b15c

# Install Go
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
sudo apt-get -y --force-yes install bison
sudo echo "[[ -s "$HOME/.gvm/scripts/gvm" ]] && source $HOME/.gvm/scripts/gvm >> ~/.bashrc
source ~/.bashrc
gvm install go1.4

# Use Go v1.4
gvm use go1.4
export GOROOT_BOOTSTRAP=$GOROOT

# Install all of the necessary ngrok tools to allow remote ssh capabilities
git clone git://github.com/inconshreveable/ngrok.git
cd ngrok && make
bin/ngrok -proto=tcp 22
