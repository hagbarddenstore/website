+++
date = "2015-06-24T10:39:00+02:00"
draft = false
title = "Static DNS with DHCP on CoreOS"
slug = "static-dns-with-dhcp-on-coreos"
tags = [ "coreos", "dns", "infrastructure" ]
categories = [ "coreos", "infrastructure" ]
+++

TL;DR;

How to set static DNS servers while still getting IP and routes from the DHCP
server in CoreOS.

<!--more-->

### Problem

I've setup two servers running CoreOS and SkyDNS to provide DNS resolution in
my AWS VPC, creating a DHCP option set which used the two CoreOS instances as
the DNS servers, which meant that the CoreOS instances got themselves as their
DNS server. This meant that whenever the instances where unavailable they
couldn't resolve any names, which meant I couldn't pull Docker images.

### The solution

To fix this problem, I figured I wanted to set a static DNS, which is easy
with the following commands:

```
# echo "nameserver 8.8.8.8" > /etc/resolv.conf
# echo "nameserver 8.8.4.4" >> /etc/resolv.conf
```

But this solution doesn't persist between boots or whenever the network service
is restarted, since the dhcpclient will overwrite the ```/etc/resolv.conf```
file. So, to have a permament solution I needed to add the configuration into
the cloud-config file. My initial cloud-config looked like this:

```
#cloud-config

coreos:
  etcd:
    discovery: https://discovery.etcd.io/2d8e9b50bc44d85d0e002767a86eff3a
    addr: $private_ipv4:4001
    peer-addr: $private_ipv4:7001
  units:
    - name: etcd.service
      command: start
    - name: fleet.service
      command: start
    - name: 00-eth0.network
      runtime: true
      content: |
        [Match]
        Name=eth0

        [Network]
        DHCP=yes
        DNS=8.8.8.8
        DNS=8.8.4.4
```

Which looked like it should work and it did work, but with the funny exception
that it used the DNS servers I had specified and also the one from DHCP. So my
```/etc/resolv.conf``` looked something like this:

```
nameserver 8.8.8.8
nameserver 10.0.0.10
nameserver 10.0.0.20
nameserver 8.8.4.4
```

So the ```/etc/resolv.conf``` now contains two correct lines and two wrong
lines. The 10.0.0.{10,20} addresses are the addresses to the CoreOS instances.

So, after looking through the
[systemd.network](http://www.freedesktop.org/software/systemd/man/systemd.network.html)
documentation some more, I found that you should add the following lines to your
cloud-config:

```
[DHCP]
UseDNS=false
```

This gave me the following final cloud-config:

```
#cloud-config

coreos:
  etcd:
    discovery: https://discovery.etcd.io/2d8e9b50bc44d85d0e002767a86eff3a
    addr: $private_ipv4:4001
    peer-addr: $private_ipv4:7001
  units:
    - name: etcd.service
      command: start
    - name: fleet.service
      command: start
    - name: 00-eth0.network
      runtime: true
      content: |
        [Match]
        Name=eth0

        [Network]
        DHCP=yes
        DNS=8.8.8.8
        DNS=8.8.4.4

        [DHCP]
        UseDNS=false
```

Which gave me the following ```/etc/resolv.conf``` file:

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

Success! Now I have a CoreOS cluster with static DNS servers which persist
between reboots and network restarts.

### Warning

Do not copy and paste the cloud-config examples into your cloud-config before
you edit the discovery token.
