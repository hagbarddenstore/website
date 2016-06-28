+++
date = "2016-06-28T21:55:00+02:00"
draft = false
title = "Ansible baby steps"
slug = "ansible-baby-steps"
tags = [ "ansible" ]
categories = [ "ansible" ]
+++

A light introduction to Ansible, promoting best practices and install cowsay
on Ubuntu 14.04.

<!--summary-->

What the hell is Ansible you ask? Well, I'm here to help!

Ansible is a tool to configure Linux (And Windows) servers via SSH and Python
scripts. It allows you to write scripts in
[YAML](https://en.wikipedia.org/wiki/YAML) and Python, which are executed
against and on remote servers.

Why should you use Ansible? You should use Ansible if you want to avoid
tedious and error prone manual work. Sure, it's fine to run a few commands
on your server to install a few applications, change some configuration
files and so on, but fast forward a year, do you still remember what you did?
Can you quickly run those commands again if you need a second server or need
to replace the existing server?

If you answered yes on both both questions, Ansible isn't for you. However, if
you didn't answer yes on both questions, tag along on my journey to teach you
what Ansible is, how to use it for a single server and in large deployments.

## Install Ansible

First things first, we need to install Ansible onto your computer, this is the
control computer, the one that executes the commands on the remote targets. The
target computers doesn't need to have Ansible installed (But they do need
Python installed!).

The easiest and recommended way of installing Ansible is via Pythons
`pip` tool.

Run the following command to install Ansible via pip:

```
pip install --user ansible
```

This installs Ansible into my local Python library, which on my Mac OS X
computer is located at `/Users/myname/Library/Python/2.7/bin/ansible`. Be
sure to add `/Users/myname/Library/Python/2.7/bin` to your `$PATH` variable
to be able to run Ansible properly.

Run `ansible --version` to verify you have a working installation.

## Your first command

Let's start off by pinging your computer:

```
ansible -m ping localhost
```

This will print something similar to this:

```
localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

If you get a warning about a missing host file (`/etc/ansible/hosts`), just
ignore it, we won't use that file anyway.

The command we ran is Ansibles equivalent of running `ping localhost`, but
it verifies that it can properly connect to the host. In the case of
localhost, it should always work.

## Ad-hoc commands

Remember I said earlier that Ansible is a bunch of scripts you can run
against your targets? Well, Ansible can run stand-alone commands against
your targets as well.

To print the current time according to your computer, run this:

```
ansible -a "date" localhost
```

The expected output looks something like this:

```
localhost | SUCCESS | rc=0 >>
Tue Jun 28 22:15:10 CEST 2016
```

You now know how to run ad-hoc commands against your computer.

## Recap

Let's recap what we've learnt so far.

1. How to install Ansible
2. How to make sure the connection to a target works
3. How to display the current date and time according to a target

But let's dig a bit deeper and try to understand what the parameters to
the `ansible` command means.

* `-m` = The module to run. A module in Ansible is a Python script to be
	executed on the target. The default module if none is specified is
	the shell module. It executes it's arguments as a standard shell command.
* `-a` = The module arguments. A module can accept zero or more arguments to
	decide what to do. In the case of figuring out the targets date, we used
	`-a` with a value of `date` but didn't specify a module to run. This
	forwards `date` to the shell module, which runs the command.
* localhost = The host pattern to match against. We used the full name of the
	host, but you can specify a regex as well, like this: `db[0-9]`, which
	will try to connect to all hosts matching the regex. This however, requires
	an inventory file. More on that later.

## Inventories

So, let's talk about inventories. An inventory is an ini-like file which
contains all your targets. It can look like this:

```
127.0.0.1
```

Altough that will work, it's not very helpful. Let's add a name to the host.

```
my-computer ansible_host=127.0.0.1
```

This gives is a nicer output, but it requires the remote target to have a
user named the same as your local user. Let's add that:

```
my-computer ansible_host=127.0.0.1 ansible_user=myname
```

Save the file somewhere, call it whatever. I usually create a directory for
my project and create a folder called `inventories` inside that folder, then
save my inventory file inside that directory. So I end up with something
like this:

```
.
└── inventories
    └── development
```

My inventory file is called development.

Now we have a complete inventory. To add more targets, simply add a new
line with the information needed.

## Playbooks

The collection of scripts to be applied to a target are called a playbook in
Ansible. Let's make one!

Open your editor and type the following:

```
---
- hosts: my-computer
  tasks:
    - name: install cowsay
      apt: >
        name=cowsay
        update_cache=yes
      become: yes
```

And that's your first playbook! Save it as playbook.yml in your project directory.

Let's explain the parts of it.

`- hosts: my-computer` defines which hosts to apply the tasks to. This can
contain the name of a host or a regex to match hosts. It can also be a group
or the special group `all` which matches all hosts in an inventory.

`tasks:` defines a list of tasks to be executed from top to botton on the
target.

`- name: install cowsay` is your first task. The name isn't required, but
highly recommended to have. You can name it whatever you want.

`apt: >` let's Ansible know that we want to execute the `apt` module.

`name=cowsay` is the first argument to the `apt` module. It's the name of
the package we'd like to install. Different modules
have different arguments.

`update_cache=yes` lets the `apt` know we want to run `apt-get update` before
installing the package.

`become: yes` lets Ansible know that we want to run this module with `sudo`.
So `become: yes` is equivalent to `sudo my-module`.

Now that we understand the playbook, let's run it!

```
ansible-playbook -i inventory/development playbook.yml
```

We're using a new command, `ansible-playbook`, which is what's used to
execute a playbook against targets.

The `-i inventory/development` tells Ansible to use our inventory file
to create a collection of targets to execute the playbook against.

When you run this command, you should end up with something like this:

```
PLAY [my-computer] *************************************************************

TASK [setup] *******************************************************************
ok: [my-computer]

TASK [install cowsay] **********************************************************
changed: [my-computer]

PLAY RECAP *********************************************************************
my-computer                : ok=2    changed=1    unreachable=0    failed=0
```

This let's us know that the task `install cowsay` ran and it changed something
on the target. If you run the playbook again, it'll say `ok` for that task
instead of `changed`.

Run `ansible -i inventory/development -a "cowsay" all` to verify that cowsay
was properly installed.

It should print something like this:

```
my-computer | SUCCESS | rc=0 >>
 __
<  >
 --
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Congratulations! You've created your first Ansible playbook and inventory.

That's it for today.

## Read more

* [Ansible](http://docs.ansible.com/ansible/)
* [Inventories](http://docs.ansible.com/ansible/intro_inventory.html)
* [Host patterns](http://docs.ansible.com/ansible/intro_patterns.html)
* [Playbooks](http://docs.ansible.com/ansible/playbooks.html)
* [Best practices](http://docs.ansible.com/ansible/playbooks_best_practices.html)

As always, if you have a comment, don't hesitate to reach out to me on
Twitter [@hagbarddenstore](https://twitter.com/hagbarddenstore) or via
email [hagbarddenstore@gmail.com](mailto:hagbarddenstore@gmail.com) or
via IRC [Freenode](irc://irc.freenode.net) where I go by the name `Kim^J`.
