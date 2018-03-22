# raspberry-pi-cluster-install
Contains installation scripts for the master and slave raspberry pi's running Raspbian

## Equipment

The equipment used for this project is listed below:
* 10 x Raspberry Pi 3
* 10 x Class 10 SD card
* 10 x Ethernet Cables
* 10 x USB Cables
* Network Switch
* USB Charging Hub

## Master Installation

To prepare the master node simply ssh into the raspberry pi clone this repository and run the `general/install.sh` script.

```
$ ssh pi@MasterNode
$ git clone https://github.com/fufu70/raspberry-pi-cluster-install
$ sudo bash ./raspberry-pi-cluster-install/general/install.sh
```

## Slave Installation

Once your master has been installed on to the 