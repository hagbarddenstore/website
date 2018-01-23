+++
draft = false
title = "Install Gitlab on Ubuntu 16.04"
date = "2018-01-23T11:39:00+01:00"
slug = "install-gitlab-on-ubuntu-1604"
tags = [ "ubuntu", "gitlab" ]
categories = [ "ubuntu" ]
+++

TL;DR;

A short description on how to install Gitlab Community Edition on Ubuntu 16.04
without using magic scripts.

<!--more-->

If you, like me, dislike using magic scripts to install stuff, then this is the
post for you. If not, please read the official installation instructions on
https://about.gitlab.com/installation/#ubuntu.

## Add Gitlabs APT key

First we need to add the GPG key. This key is used for both the official
package repository and the China mirror.

```
curl -L https://packages.gitlab.com/gitlab/gitlab-ce/gpgkey | sudo apt-key add -
```

## Add the Ubuntu 16.04 APT repository

To add the official repository to APT, run:

```
echo "deb https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ xenial main" | sudo tee /etc/apt/sources.list.d/gitlab.list
```

### Bonus: APT mirror in China

If your server is located in China, there's a great change it might not be
able to download Gitlab via the official mirrors. But, don't fear, there are
mirrors inside China.

Run the following command, instead of the previous command to add the China
mirror:

```
echo "deb https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/gitlab.list
```

No matter if you added the official repository or the China mirror, run the
following command to update APT:

```
sudo apt-get update -y
```

## Install required packages

To install all packages needed by Gitlab, please run:

```
sudo apt-get install -y openssh-server ca-certificates gitlab-ce
```

The `gitlab-ce` package will install `redis`, `nginx` and `postgresql` as
needed by Gitlab. There is a package called `gitlab` which doesn't include
these dependencies, but do tread carefully.

## Configure and start all services

To setup `Gitlab`, run the following command:

```
sudo gitlab-ctl reconfigure
```

This will fire up Chef and run the included recipes for Gitlab, when done,
it will start all services needed for normal operation.

That's it! Gitlab Community Edition and it's dependencies are install. Visit
http://your_server_ip/ in your webrowser to setup the root password.

If you want to modify the installation (Perhaps to add HTTPS), please consult
the official documentation on https://docs.gitlab.com/omnibus/README.html
