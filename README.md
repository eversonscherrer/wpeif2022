# WPEIF-2022
This is a repository that contains the experiment that was submitted in the paper to XIII Workshop on Experimental Research on the Internet of the Future.

Conference link
http://sbrc2022.sbc.org.br/xiii-workshop-de-pesquisa-experimental-da-internet-do-futuro-wpeif-2022/

# Paper Title

A lifecycle experience of PolKA: From prototyping to deployment at Géant Lab with RARE/FreeRouter

# Requirement

Basic Linux/Unix knowledge
Service provider networking knowledge

# Topology
The paper used this diagram to describe a PolKA demo scenario.

![Topology](https://github.com/eversonscherrer/wpeif2022/blob/main/Images/topology.png)

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

# PolKA Experimentation

## 1 - To access the router, just access via telnet or ssh, in our demo, we use telnet.

```telnet <localhost> <port>```

For example, Access Router R5, to access another router, just change the port.
```console
telnet 127.0.0.1 2525
```

## 2 - Check running-config for PolKA tunnel1.

```console
show running-config interface tunnel1
```

````
R5#show running-config interface tunnel1
interface tunnel1
 description POLKA tunnel shortest ipv4 from R5 -> R6
 tunnel vrf v1
 tunnel source loopback0
 tunnel destination 20.20.20.6
 tunnel domain-name 20.20.20.1 20.20.20.2
 tunnel mode polka
 vrf forwarding v1
 ipv4 address 30.30.30.1 255.255.255.252
 no shutdown
 no log-link-change
 exit
!
````

## 3 - Check running-config for PolKA tunnel4.

```console
show running-config interface tunnel4
```
````
R5#show running-config interface tunnel4
interface tunnel4
 description POLKA tunnel longues ipv6 from R5 -> R6
 tunnel vrf v1
 tunnel source loopback0
 tunnel destination 2020::6
 tunnel domain-name 2020::1 2020::4 2020::3 2020::2
 tunnel mode polka
 vrf forwarding v1
 ipv6 address 4040::1 ffff:ffff:ffff:ffff::
 no shutdown
 no log-link-change
 exit
!
````


## 4 - Check if the tunnels it's work, just use the command below. If the tunnels and interfaces is working, after insert the command you see "up".
```console
show interface summary
```

```
R5#show interfaces summary
interface  state  tx       rx      drop
template1  admin  667      0       64014
loopback0  up     286756   0       0
ethernet1  up     1035022  951379  0
ethernet2  up     652494   456591  0
tunnel1    up     0        0       0
tunnel2    up     0        0       0
tunnel3    up     26910    0       0
tunnel4    up     407684   0       230
```

## 5 - Check the routeID and parameters from PolKA Tunnels 1 and 4. In this point its intersting to notice that 

Details from Tunnel 1

```console
show polka routeid tunnel1
```

```
R5#show polka routeid tunnel1
mode  routeid
hex   00 00 00 00 00 00 00 00 00 00 26 d9 4d b0 6b 6b
poly  1001101101100101001101101100000110101101101011

index  coeff     poly   crc    equal
0      00010000  27499  27499  true
1      00010001  2      2      true
2      00010003  6      6      true
3      00010005  23389  23389  true
4      00010009  56209  56209  true
5      0001000f  33006  33006  true
6      00010011  0      0      true
7      0001001b  55909  55909  true
8      0001001d  33248  33248  true
9      0001002b  8069   8069   true
```

Details from Tunnel 4

```console
show polka routeid tunnel4
```

````
R5#show polka routeid tunnel4
mode  routeid
hex   00 00 00 00 00 00 69 76 5d c5 d7 be 75 93 96 9a
poly  1101001011101100101110111000101110101111011111001110101100100111001011010011010

index  coeff     poly   crc    equal
0      00010000  38554  38554  true
1      00010001  4      4      true
2      00010003  6      6      true
3      00010005  2      2      true
4      00010009  3      3      true
5      0001000f  3401   3401   true
6      00010011  0      0      true
7      0001001b  25646  25646  true
8      0001001d  21719  21719  true
9      0001002b  64376  64376  true
````

## 6 - Policy Based Routing (PBR)

We use a PBR to make traffic engineering (TE) in our experiment. This example demonstrates the shortest path with a PolKA tunnel ipv4. The ICMP packets were left from R7 and forwarded to R5, categorized with an access-list named polka4. After that, with a PBR that can be the next hope sent between edge router R5, in this case passing through core routers R1 and R2 to reach at edge router R6 over PolKA tunnel 1.

| ![Shortest Path](https://github.com/eversonscherrer/wpeif2022/blob/main/Images/polka-tunnel-shortest-path.png)|
|:--:| 
| *Shortest Path* |

In the longest path, the ICMP packets left from R7 and forwarded to R5, categorized with an access-list named polka6. After that, a PBR forward to the next hope sent between edge router R5, passing through core routers R1, R4, R3, and R2 to reach edge router R6 over PolKA tunnel 4.

|![Shortest Path](https://github.com/eversonscherrer/wpeif2022/blob/main/Images/polka-tunnel-longest-path.png)|
|:--:| 
| *Longest Path* |

To see the access list that classifies the traffic, just run the command below. In our example, we categorize ICMP protocol. For this we create two ```access-list``` one for ipv4 named polka4 and another to ipv6 named polka6.

#### Access-List polka4
```console
show access-list polka4
```

```
R5#show access-list polka4
 sequence 10 permit 1 7.7.7.0 255.255.255.252 all 20.20.20.6 255.255.255.255 all
  match=tx=0(0) rx=0(0) drp=0(0) accessed=21:26:33 ago, 00:00:00 timeout
```

#### Access-List polka6

```console
show access-list polka6
```

```
R5#show access-list polka6
 sequence 10 permit 58 7777:: ffff:ffff:ffff:ffff:: all 2020::6 ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff all
  match=tx=0(0) rx=0(0) drp=0(0) accessed=21:26:33 ago, 00:00:00 timeout
```

#### To show ipv4 PBR

```console
show ipv4 pbr v1
```

````
R5#show ipv4 pbr v1
 sequence 10 polka4 v1 nexthop 30.30.30.2
  match=tx=0(0) rx=0(0) drp=0(0) accessed=never ago, 00:00:00 timeout
````

Note that this PBR forwards all ICMP ipv4 traffic coming from R7 to the PolKA shortest path tunnel.

#### To show ipv6 PBR

```console
show ipv6 pbr v1
```
````
R5#show ipv6 pbr v1
 sequence 10 polka6 v1 nexthop 4040::2
  match=tx=0(0) rx=344256(5379) drp=0(0) accessed=1d21h ago, 00:00:00 timeout
````

Note that this PBR forwards all ICMP ipv6 traffic coming from R7 to the PolKA tunnel the longest path.

## 7 - Verification

### 1 - Ping test using a shortest path with PolKA tunnel 1

As explained, we started the traffic from R7, now run the commands in R7.  

Here we demonstrate a ICMP traffic from R7 to R6, by PolKA tunnel1 in R5.
```console
ping 20.20.20.6 /vrf v1 /repeat 111111
```

|![Ping Shortest Path](https://github.com/eversonscherrer/wpeif2022/blob/main/Images/pbr-ipv4.png)|
|:--:| 
| *Ping Shortest Path* |



### 2 - Ping test using a longest path with PolKA tunnel 4

Here we demonstrate a ICMP traffic from R7 to R6, by PolKA tunnel4 in R5.
```console
ping 2020::6 /vrf v1 /repeat 111111
```

|![Ping Longest Path](https://github.com/eversonscherrer/wpeif2022/blob/main/Images/pbr-ipv6.png)|
|:--:| 
| *Ping Longest Path* |