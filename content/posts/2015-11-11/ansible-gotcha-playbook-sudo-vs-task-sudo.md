+++
date = "2015-11-11T14:33:00+01:00"
draft = false
title = "Ansible gotcha: Playbook sudo vs task sudo"
slug = "ansible-gotcha-playbook-sudo-vs-task-sudo"
tags = [ "ansible", "ops" ]
categories = [ "ansible" ]
+++

TL;DR;

When running a playbook with `sudo: yes`, it also runs the facts module
with sudo, so `ansible_user_dir` will have the value of the root user, rather
than the expected home directory of the `ansible_ssh_user`.

<!--more-->

So, today I where pushing some generated SSH keys to servers to be able to pull
changes from git without having to add each servers respective SSH key to the
git server. Since I'm using [Ansible](http://www.ansible.com) to automate
configuration of servers, I setup the task like this:

```
- name: push git deploy key
  copy:
    dest="{{ ansible_user_dir }}/.ssh/{{ item.name }}"
    content="{{ item.content }}"
  with_items:
    - name: id_rsa
      content: "{{ git_deploy_key_private }}"
    - name: id_rsa.pub
      content: "{{ git_deploy_key_public }}"
  no_log: True
  tags: configuration
```

Nothing wrong with the above code, I verified with `ansible -m setup host` that
`ansible_user_dir` had the correct value. But, when you add `sudo: yes` to the
playbook, like this:

```
- hosts: host
  sudo: yes
  roles:
    - { role: deploy_git_keys }
```

Then [Ansible](http://www.ansible.com) runs the facts module with sudo, which
makes the `ansible_user_dir` contain the home directory of the user sudo was
ran as, which by default is `root`. So, it had the value of `/root` rather
than my expected `/home/ubuntu`. So the keys where pushed to `/root/.ssh/`
rather than my expected `/home/ubuntu/.ssh/`.

So, the solution is to not have `sudo: yes` in your playbook, but have them on
the various tasks that really need it or to not rely on `ansible_user_dir`, but
I prefer the former.

You can verify this behaviour by running the following playbook:

```
---
- hosts: all
  sudo: yes
  tasks:
    - name: print ansible_user_dir
      debug:
        var=ansible_user_dir
    - name: print $HOME
      command: echo $HOME

- hosts: all
  tasks:
    - name: print ansible_user_dir
      debug:
        var=ansible_user_dir
      sudo: yes
    - name: print $HOME
      command: echo $HOME
      sudo: yes

- hosts: all
  sudo: no
  tasks:
    - name: print ansible_user_dir
      debug:
        var=ansible_user_dir
    - name: print $HOME
      command: echo $HOME
```

The first play is gonna display `/root` twice, the second play will display
`/home/ubuntu` first and then `/root` and the third play will show
`/home/ubuntu` twice.
