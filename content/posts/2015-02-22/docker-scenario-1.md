+++
date = "2015-02-22T16:17:00+02:00"
draft = true
title = "Docker: Scenario 1"
slug = "docker-scenario-1"
tags = [ "docker" ]
categories = [ "A pragmatic guide to Docker" ]
+++

TL;DR;

How to setup a basic Docker image preloaded with nginx hosting a static
content website.

<!--more-->


docker pull nginx

Dockerfile

    FROM nginx

    COPY content/ /usr/share/nginx/html




Setting up an nginx instance hosting static content