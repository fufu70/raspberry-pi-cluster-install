# Clean Installation

This document marks how to cleanly install the open mpi libraries and compile / run an open mpi script. To start the process ssh into your master node and update `apt-get`

### Master Node

```
ssh pi@<Master-Node-IP>
sudo apt-get update
```

Next all necesarry packages for working in your master node, we installed vim and git
```
sudo apt-get install vim git
```

Install all of the necessary openmpi libraries to work in the supported openmpi languages, fortran and c.

```
sudo apt-get install gfortran openmpi-bin libopenmpi-dev openmpi-doc
```

### Slave Node

Now ssh into your slave node and update `apt-get`. Once the update process has run, install all of the encessary packages for openmpi to run.

```
ssh pi@<Slave-Node-IP>
sudo apt-get update
sudo apt-get install gfortran openmpi-bin libopenmpi-dev openmpi-doc
```
Once completed, exit out of the slave node and return into the master node.

```
exit 
```

### Master Node

In the master node we want to add the Slave and Master IP addresses to the known hosts to allow OpenMPI to use them in the execution process. Add the following 2 lines at the bottom of your `/etc/hosts` file. The file is root protected so edit the file with a sudo enabled user.

``` 
<Master-Node-IP>  Mst
<Slave-Node-IP>   Slv
```

Once your `/etc/hosts` file has been edited then create a keygen and send it to your Slave node. This allows you to ssh into your Slave node without receiving a password prompt, it also allows OpenMPI to ssh into your slave node and send commands to it.

```
ssh-keygen
ssh pi@Slv mkdir -p .ssh
cat .ssh/id_rsa.pub | ssh pi@Slv 'cat >> .ssh/authorized_keys'
```

Create a simple OpenMPI file to view all of the current processes in your clusters OpenMPI world. We called this script `call-procs.c`

```C
#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    
    MPI_Init(NULL, NULL);

    
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    
    char processor_name[MPI_MAX_PROCESSOR_NAME];
    int name_len;
    MPI_Get_processor_name(processor_name, &name_len);

    
    printf("Hello world from processor %s, rank %d"
           " out of %d processors\n",
           processor_name, world_rank, world_size);

    
    MPI_Finalize();
}
```

Compile your `call-procs.c` script and call the outputted file `call-procs`. Upload the call procs file onto your slave node and run it.

```
mpicc call-procs.c -o call-procs
sshpass -p raspberry sftp "pi@Slv" << EOF
put call-procs
EOF
mpiexec -H Mst,Slv call-procs
```

You should receive the following output below:
```
Hello world from processor raspberrypi, rank 0 out of 2 processors
Hello world from processor raspberrypi, rank 1 out of 2 processors
```
