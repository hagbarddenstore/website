+++
draft = false
title = "Holding packages in Ubuntu"
date = "2017-01-10T13:20:24+01:00"
slug = "holding-packages-in-ubuntu"
tags = [ "ubuntu", "debian", "package management" ]
categories = [ "ubuntu" ]
+++

TL;DR;

A quick tip on how to hold packages at a given version in Ubuntu. Will work
for other Debian based operating systems as well.

<!--more-->

First, install the package at the given version. Here's how to install
Elasticsearch 2.4.1:

```
sudo apt-get install -y elasticsearch=2.4.1
```

Verify it's installed with the correct version by running:

```
dpkg -l | grep elasticsearch
```

This should return a line that looks like this:

```
hi  elasticsearch                    2.4.1                               all          Elasticsearch is a ...
```

Now it's time to tell dpkg to hold this version:

```
echo "elasticsearch hold" | sudo dpkg --set-selections
```

Verify by running:

```
dpkg --get-selections | grep elasticsearch
```

That's it! From now on, each `sudo apt-get upgrade` or equivalent won't
upgrade the Elasticsearch package. Neat!

