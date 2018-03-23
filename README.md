# raspberry-pi-cluster-install
Contains installation scripts for the master and slave raspberry pi's running Raspbian

## Equipment

The equipment used for this project is listed below:
* 10 x [Raspberry Pi 3](https://www.amazon.com/Raspberry-Pi-RASPBERRYPI3-MODB-1GB-Model-Motherboard/dp/B01CD5VC92/ref=sr_1_3?s=electronics&ie=UTF8&qid=1521722702&sr=1-3&keywords=raspberry+pi+3&dpID=51Vt9f26ryL&preST=_SX300_QL70_&dpSrc=srch)
* 10 x [Class 10 SD card](https://www.amazon.com/SanDisk-Class-Flash-Memory-Card/dp/B00N9BECHY/ref=sr_1_7?ie=UTF8&qid=1521722434&sr=8-7&keywords=class+10+sd+card+8GB&dpID=51Mw1XUHxKL&preST=_SX300_QL70_&dpSrc=srch)
* 10 x [Ethernet Cables](https://www.amazon.com/iMBAPrice-Cat5e-Network-Ethernet-IMBA-CAT5-15BK-10PK/dp/B00I8VK5OO/ref=sr_1_1?s=electronics&ie=UTF8&qid=1521722504&sr=1-1&keywords=ethernet+cables+10+pack)
* 10 x [USB Cables](https://www.amazon.com/Mopower-Samsung-Blackberry-Motorola-Smartphones/dp/B017SNCCGQ/ref=sr_1_sc_1?s=electronics&ie=UTF8&qid=1521722532&sr=1-1-spell&keywords=usb+microcables+10+pack)
* [Network Switch](https://www.amazon.com/NETGEAR-16-Port-Gigabit-Ethernet-Unmanaged/dp/B01AX8XHRQ/ref=sr_1_3?s=electronics&ie=UTF8&qid=1521722574&sr=1-3&keywords=network%2Bswitch%2B12%2Bport&th=1)
* [USB Charging Hub](https://www.amazon.com/Tripp-Lite-10-Port-Charging-U280-010/dp/B012EAHX7G/ref=sr_1_37?s=electronics&ie=UTF8&qid=1521722654&sr=1-37&keywords=usb+charging+station+10+port)

## Master Installation

To prepare the master node simply ssh into the raspberry pi clone this repository and run the `general/install.sh` script.

```
$ ssh pi@MasterNode
$ git clone https://github.com/fufu70/raspberry-pi-cluster-install
$ sudo bash ./raspberry-pi-cluster-install/general/install.sh
```

## Slave Installation

Once your master has been installed ssh back into the master node, populate your ip list for all of your slaves IP addresses into a file in your user directory, `/home/pi`. The file should look similar to this:

```
192.168.0.29
192.168.0.30
192.168.0.31
192.168.0.32
```

In your master node run the `master/install.sh` script. This will run an installation script on all of the slaves listed in your slave IP file.

```
$ sudo bash ./raspberry-pi-cluster-install/master/install.sh
Enter file path to Slave IP's: 
/path/to/ip_file
```

Once the cluster has been installed you can provision your slaves with all of the necessary code to run your parallel project. To send your scripts to all of your nodes run the `master/send.sh` script and specify the nodes to send it to and the file to send.

```
$ sudo bash ./raspberry-pi-cluster-install/master/send.sh
Enter file path to Slave IP's: 
/path/to/ip_file
Enter file (with path) to send: 
/path/to/mpi_script
```

Once the file has been sent to all of your slaves run your mpi command with all of your hostnames

```
$ mpiexec -H Mst,Mst,Mst,Mst,Slv,Slv,Slv,Slv call-procs
```

## Compiling Scripts

To compile the `call-procs.c` file simply ssh into your node and run the `mmpicc` command

```
$ mpicc raspberry-pi-cluster-install/scripts/call-procs.c -o call-procs
```

`euler.c` is a bit different as it needs the math library to operate. To include the library append `-lm` after the `mpicc` command.

```
$ mpicc -lm raspberry-pi-cluster-install/scripts/euler.c -o euler
```