# WPEIF-2022
This is a repository that contains the experiment that was submitted in the paper to XIII Workshop on Experimental Research on the Internet of the Future.

# Paper Title

A lifecycle experience of PolKA: From prototyping to deployment at Géant Lab with RARE/FreeRouter

# Requirement

Basic Linux/Unix knowledge
Service provider networking knowledge

# Diagram
The paper used this diagram to describe a PolKA demo scenario.

![Diagram](https://github.com/eversonscherrer/wpeif2022/blob/main/Images/topology.png)

# Operating system supported
This point exposes how to install freerouter and execute a edge-core topology with PolKA.

- Debian 10 (stable aka buster)
- Ubuntu 18.04 (Bionic beaver)
- Ubuntu 20.04 (Focal fossa)


# Freertr
Freertr is a control plane: Router OS process speaks various network protocols, (re)encap packets, and exports forwarding tables to hardware switches. Basically, it is only necessary to install the Java Runtime Environment (JRE). Below is demonstrated how to install it on operating systems: Linux, Windows and macOS.

## Install JRE
### Linux
For demonstration purposes, the Debian-based Linux installation was chosen.
```console
#sudo apt-get install default-jre-headless --no-install-recommends
```

### MacOS
```console
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk list java
sdk install java 17.0.2-open
sdk default java 17.0.2-open
java -version
```

### Windows
In order to install the Windows version of Java, you need to visit the official Java website and download the Windows executable. After the download, check if your user has permission to install and perform the installation through the graphical environment. 

## Install Freertr
The freeRouter homepage is at freertr.net. Starting from this page, you'll find various resources such as source code (there is also a GitHub mirror), binaries, and other images that might be of your interest. From there we just download the freeRouter jar files.


```console
#wget freertr.net/rtr.jar
````

# Launch the Topology
Now it's time to run the topology, to run it, download all the hardware and software files that are in the repository, in the same folder.

**NOTE**
> To orchestrate the execution of the topology we use ```tmux```, if you don't have it installed, remember to install it.
```console
sudo apte-get install tmux
or
brew install tmux
````
There is a file called ```start-topology.sh``` in the repository. This file orchestrates the execution of all routers in a single run.

```console
#chmod +x start-topology.sh
#./start-topology.sh
```

# Verification

1 - To access the router through the network, just access via telnet or ssh, in our demo, we use telnet.

```telnet <localhost> <port>```

For Example, Access Router R5, to access another router, just change the port.
```console
telnet 127.0.0.1 2525
```

2 - Check running-config for PolKA tunnel1.

```console
R5#show running-config interface tunnel1
```

![Tunnel 1](https://github.com/eversonscherrer/wpeif2022/blob/main/Images/tunnel1.png)


3 - Check running-config for PolKA tunnel4.

```console
R5#show running-config interface tunnel4
```

![Tunnel 4](https://github.com/eversonscherrer/wpeif2022/blob/main/Images/tunnel4.png)









