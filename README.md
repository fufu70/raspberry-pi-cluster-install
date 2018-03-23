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

All of the SD Cards were pre flashed with [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/). The Raspberry Pi Foundation has a [short guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) on how to install it on your SD Cards

## Master Installation

To prepare the master node simply ssh into the raspberry pi clone this repository and run the `general/install.sh` script.

```
$ ssh pi@MasterNode
$ git clone https://github.com/fufu70/raspberry-pi-cluster-install
$ sudo bash ./raspberry-pi-cluster-install/general/install.sh
```

## Provisioning SD cards

Once the master node has been provisioned with all of the necessary tools you can then create an image from the SD card and flash it on to all of the Slave SD cards as the only difference between the master and slave nodes are where the code is being executed. A good tutorial on how to create images from and flash images to your SD cards is [ThePiHuts process](https://thepihut.com/blogs/raspberry-pi-tutorials/17789160-backing-up-and-restoring-your-raspberry-pis-sd-card).

Another tool that works very well for flashing SD cards quickly is [etcher](https://etcher.io/) as it will quickly try and find your external drive to flash with the provided raspberry image.

## Slave Installation

Each slave needs to be a near exact copy of the master environment, with all of the necessary packages to run MPI along with ssh access with a key instead of a password. MPI uses ssh to create connections with its slaves. Firstly the slaves need to be installed properly, if the slave SD cards were not provisioned then the best action is to ssh into the machine and run the installation script:

```
$ ssh pi@SlaveNode
$ git clone https://github.com/fufu70/raspberry-pi-cluster-install
$ sudo bash ./raspberry-pi-cluster-install/general/install.sh
```

After the installation script has finished we need to go back to the master, generate an ssh key to use on all of the slaves and then upload the ssh key to all of the slaves. If the default values for the `ssh-keygen` command are used it will save the new ssh key at `/home/pi/.ssh/id_rsa.pub` and set an empty passphrase for the key.

```
$ ssh-keygen
$ ssh pi@SlaveNode mkdir -p .ssh
$ cat .ssh/id_rsa.pub | ssh pi@SlaveNode 'cat >> .ssh/authorized_keys'
```

To confirm that your key has been upload from master try and `ssh` into your slave node from your master node, you should not be prompted for a password. To create hostnames for your slaves for your master add the ip address and hostname to your /etc/hosts file.

```
$ sudo echo "<Slave0IPAddress> Slave0" >> /etc/hosts
$ sudo echo "<Slave1IPAddress> Slave1" >> /etc/hosts
$ sudo echo "<Slave2IPAddress> Slave2" >> /etc/hosts
```

To ensure that your changes have been applied try to ssh into one of your slaves using the hostname instead of the IP address, you should not be prompted for a password.

```
$ ssh pi@Slave0
```

## Mass Slave Installation

To install your raspberry pi's on a large scale, ssh back into the master node, and  populate your ip list for all of your slaves IP addresses into a file in your user directory, `/home/pi`. The file should look similar to this:

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

Once the file has been sent to all of your slaves run your mpi command with your host names. In the example below both `Mst` and `Slv` have 4 core available so they are repeated 4 times in the hostname array.

```
$ mpiexec -H Mst,Mst,Mst,Mst,Slv,Slv,Slv,Slv call-procs
```

## Compiling Scripts

To compile the `call-procs.c` file simply ssh into your node and run the `mmpicc` command

```
$ mpicc raspberry-pi-cluster-install/scripts/call-procs.c -o call-procs
```

`euler.c` and `sine.c` are a bit different as they need the math library to operate. To include the library append `-lm` after the `mpicc` command.

```
$ mpicc raspberry-pi-cluster-install/scripts/euler.c -o euler -lm

or

$ mpicc raspberry-pi-cluster-install/scripts/sine.c -o sine -lm
```

## Thanks to

Carlos R. Morrisons [MPI examples](https://github.com/PacktPublishing/Build-Supercomputers-with-Raspberry-Pi-3)