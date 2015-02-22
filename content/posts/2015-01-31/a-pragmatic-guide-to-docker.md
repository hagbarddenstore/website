+++
date = "2015-01-31T13:38:00+02:00"
draft = true
title = "A pragmatic guide to Docker"
slug = "a-pragmatic-guide-to-docker"
tags = [ "docker" ]
categories = [ "A pragmatic guide to Docker" ]
+++

TL;DR;

A pragmatic guide to Docker based on real world examples rather than trying to
teach the plethora of commands Docker has.

<!--more-->

## Why?

As you may know, there are loads of tutorials for Docker, either explaing
simple things like how to run your first container, or more advanced stuff.

But I couldn't find a complete guide, which covers the basic, the advanced stuff
and how to apply it in your current environment or future projects.

So in an effort to change this, I'm writing this complete guide to Docker.

## What is Docker?

If you have existing knowledge of what Docker is, you may skip this part.




Introduction...

What is Docker?

Why use Docker?

Basic Docker usage

Advanced Docker usage

Using Docker in a production environment

Noteworthy tools to aid your Docker use


Introducing Docker

What is Docker?

* Eliminates dependency hell

* Build once, run everywhere

* A lightweight "VM"

Concepts

* Dockerfiles
* Images
* Containers
* Repository

Dockerfile -> Build -> { Push -> Pull -> } Run


hub.docker.com


Create Ubuntu 14.04 machine

sudo apt-get update
sudo apt-get install docker.io golang make


Pragramatic approach to Docker

Scenario 1: Setting up an nginx instance hosting static content
Scenario 2: Setting up a Go HTTP backend
Scenario 3: Setting up a load balanced Go HTTP backend with etcd
Scenario 4: Combining scenarios 1 to 3.
Scenario 5: Hosting scenario 4 in a CoreOS cluster on Amazon AWS




Docker hub doesn't work properly in Safari on OS X, use Chrome.



docker run
docker build
docker info
docker pull
docker logs
docker kill
docker ps
docker ps -a
docker start
docker stop
docker restart
docker rm
docker rmi
docker images
docker commit