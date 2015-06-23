+++
date = "2015-06-05T10:57:00+02:00"
draft = false
title = "Service discovery with SkyDNS"
slug = "service-discovery-with-skydns"
tags = [ "aws", "coreos", "skydns", "dns", "infrastructure", "etcd" ]
categories = [ "infrastructure" ]
+++

TL;DR;

A small guide on howto setup a cluster of CoreOS machines running etcd and
SkyDNS to provide service discovery of services within the cluster.

<!--more-->

### Prerequisites

Since this guide assumes you're setting this up on AWS, you'll need a working
AWS account and a working installation of [aws-cli](http://aws.amazon.com/cli/).

```
COREOS_IP=127.0.0.1

JSON='{"domain":"skydns.local.","nameservers":["8.8.8.8:53","8.8.4.4:53"],"dns_addr":"0.0.0.0:53"}'

curl http://${COREOS_IP}:4001/v2/keys/skydns/config -XPUT -d value="${JSON}"
```

```
[Unit]
Description=SkyDNS service
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
EnvironmentFile=/etc/environment
ExecStartPre=-/usr/bin/docker kill skydns
ExecStartPre=-/usr/bin/docker rm skydns
ExecStartPre=/usr/bin/docker pull skynetservices/skydns
ExecStart=/usr/bin/docker run --net host -p 53:53 -p 53:53/udp --name skydns skynetservices/skydns -machines "http://${COREOS_PRIVATE_IPV4}:4001/"
```

```
#cloud-config

coreos:
  etcd:
    discovery: https://discovery.etcd.io/7ab763e0706f17f9f8d702b3b7685231
    addr: $private_ipv4:4001
    peer-addr: $private_ipv4:7001
  fleet:
    metadata: "role=services"
  units:
    - name: etcd.service
      command: start
    - name: fleet.service
      command: start
    - name: skydns.service
      command: start
      content: |
        [Unit]
        Description=SkyDNS service
        After=docker.service
        Requires=docker.service

        [Service]
        Restart=always
        TimeoutStartSec=0
        EnvironmentFile=/etc/environment
        ExecStartPre=-/usr/bin/docker kill skydns
        ExecStartPre=-/usr/bin/docker rm skydns
        ExecStartPre=/usr/bin/docker pull skynetservices/skydns
        ExecStart=/usr/bin/docker run --net host -p 53:53 -p 53:53/udp --name skydns skynetservices/skydns -machines "http://${COREOS_PRIVATE_IPV4}:4001/"

        [X-Fleet]
        Global=true
        MachineMetadata=role=services
```

### See more

* [AWS](http://aws.amazon.com)
* [AWS CloudFormation](http://aws.amazon.com/cloudformation/)
* [CoreOS](https://coreos.com)
* [etcd](https://github.com/coreos/etcd)
* [etcdctl](https://github.com/coreos/etcd/tree/master/etcdctl)
* [fleet](https://github.com/coreos/fleet)
* [fleetctl](https://coreos.com/docs/launching-containers/launching/fleet-using-the-client/)
* [SkyDNS](https://github.com/skynetservices/skydns)