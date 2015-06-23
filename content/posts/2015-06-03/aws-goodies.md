+++
date = "2015-06-03T15:45:00+02:00"
draft = false
title = "AWS goodies"
slug = "aws-goodies"
tags = [ "aws" ]
categories = [ "aws" ]
+++

TL;DR;

A collection of snippets and scripts to be used against the Amazon Web Services
to ease management of servers.

<!--more-->

### Disclaimer

All snippets and scripts are provided as is and I provide no guarantee that
they won't destroy your environment. They work on my machine(tm).

All snippets and scripts assume you have a working installation of the
[aws-cli](http://aws.amazon.com/cli/) and have setup your credentials properly.

Most scripts also use the fantastic [jq](http://stedolan.github.io/jq/) tool.

### How to generate a new key-pair and save it into ~/.ssh

The ```export``` line is optional, if you don't use it, simply replace **$name**
with the name you want.

The ```chmod``` line is also optional, but strongly recommended, since SSH will
complain if the key is readable to the world.

```
export name=the-name-you-want

aws ec2 create-key-pair --key-name $name | \
jq ".KeyMaterial" --raw-output > ~/.ssh/$name.pem

chmod 0400 ~/.ssh/$name.pem
```

### How to get the stack status from CloudFormation

This snippet is useful in scripts to determine when a stack has reached a
certain status. Can be used to wait for a UPDATE_COMPLETED before running other
commands, like Ansible playbooks.

The ```export``` line is optional, if you don't use it, simply replace **$name**
with the name you want.

```
export name=your-stack-name

aws cloudformation describe-stacks --stack-name $name | \
jq ".Stacks[0].StackStatus" --raw-output
```

### How to sync a local folder with a remote S3 folder

```
aws s3 sync my-folder s3://my-bucket/my-folder
```