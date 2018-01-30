+++
draft = false
title = "Using AWS in China"
date = "2018-01-30T10:41:00+01:00"
slug = "using-aws-in-china"
tags = [ "aws", "china", "cn-north-1", "cn-northwest-1", "amazon web services", "amazon" ]
categories = [ "aws" ]
+++

TL;DR;

A collection of differences between non-China AWS and China AWS and how I've
solved them.

<!--more-->

Recently I got my hands on a project which is to be deployed across multiple
regions in the world, one of them being China. Naive as I where, I thought
my CloudFormation stacks would just work in China, since they worked so
perfectly in both Europe (eu-west-1) and the US (us-east-1). But... I was
wrong. Very wrong.

After quite a lot of trial and error, I finally managed to get my modified
stack running in China, success!

So, to unburden the pain from you, I've compiled a list of all the caveats
I've found so far.

This blog post assumes you're using some like CloudFormation, Terraform or
running commands via aws-cli. The experience will be different in the
AWS Console since it guides you to do the correct choices.

## Instance types

This one is quite obvious, but still a bit of a pain.

China is lagging behind a bit when it comes to instance types, so please take
an extra look into your scripts before running them to ensure that the instance
types you've selected are available.

You can find the China instance types at https://www.amazonaws.cn/en/ec2/details/.

## AMIs

This really shouldn't be a surprise at all, since it's different in all regions.
What caught my attention, was that some images (Ubuntu 16.04) aren't up to date
to the current version, it even differs across the two regions in China.

Example: In cn-north-1 Ubuntu 16.04 20180109 is available, but in cn-northwest-1
it's not. This is a bit weird, since 20180109 is available everywhere, but
cn-northwest-1.

I've written a small Python script to find all AMIs for Ubuntu 16.04 called
`image-map.py` and it contains this:

```
#!/usr/bin/env python2.7

import boto3

def main():
	client = boto3.client("ec2")

	for region in regions():
		for image in images(region):
			print "%s: %s" % (region, image.get("ImageId"))

def regions():
	client = boto3.client("ec2")

	for region in client.describe_regions().get("Regions", []):
		yield region.get("RegionName", "")

def images(region_name):
	client = boto3.client("ec2", region_name=region_name)

	for image in client.describe_images(Filters = [ { "Name": "name", "Values": [ "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180109" ] } ]).get("Images", []):
		yield image

if __name__ == "__main__":
	main()
```

Replace `ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180109` with
a string that matches your wanted AMI and then run the script twice, one with
a AWS "the world" account and one with a AWS China account. Example:

```
$ AWS_PROFILE=standard_aws_account ./image-map.py
$ AWS_PROFLE=aws_china_account ./image-map.py
```

This assumes you have setup two AWS profiles. Read more on
https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html.

## IAM trust entities

Another thing that surprised me is that IAM trust entities sometimes are named
differently. The surprise stems from that I assumed the name of the entities to
be something that's internal to AWS, in which case they are free to choose
whatever name they want, but this wasn't the case.

The entities I use are `monitoring.rds.amazonaws.com`, `ecs.amazonaws.com`
and `ec2.amazonaws.com`. Both rds and ecs are named the same in China as they
are elsewhere, but ec2 is not. It's called `ec2.amazonaws.com.cn` in China.

What I did in my CloudFormation template was to create a condition and use
`Fn::If` to select which entity name to use. Example:

```
Conditions:
  China: !Or
    - !Equals
      - cn-north-1
      - !Ref 'AWS::Region'
    - !Equals
      - cn-northwest-1
      - !Ref 'AWS::Region'
Resources:
  IamRole:
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Action:
              - sts:AssumeRole
            Effect: Allow
            Principal:
              Service:
                - !If
                  - China
                  - ec2.amazonaws.com.cn
                  - ec2.amazonaws.com
      ManagedPolicyArns:
        - !If
          - China
          - arn:aws-cn:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role
          - arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role
      Path: /
    Type: AWS::IAM::Role
```

This snippet uses the same condition to select the correct policy ARN, since
they too are different in China.

There can be other entities that follow the same scheme, but I only came
across these since I mainly use RDS, ECS and EC2, but be aware of Lambda
and other services that heavily rely on IAM roles/profiles.

## ARNs

As I just mentioned, ARNs are different in China as well, but they are quite
easy to manage, simple replace `arn:aws:` with `arn:aws-cn:` and you're done!

Given we use the condition `China` which I defined in the snippet above, we
can select the correct ARN doing this:

```
- !If
  - China
  - arn:aws-cn:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role
  - arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role
```

## Cross-region VPC peering connections

No big surprise here, given that cross-region capability is quite new and
not introduced to that many regions yet, but it still made me a bit sad.

## Non-mirrored package repositories

This caused the most pain of all issues. Package repositories aren't mirrored
in China. The Ubuntu repositories are mirrored, so if you only install packages
from those repositories, you're fine. But if you like me, run Docker or Gitlab,
you're gonna have intermittent difficulties reaching the official mirrors.

There is a solution though, since companies inside China offers mirrors that
works.

So, for Docker, replace the official
`deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable`
with a Chinese mirror provided by Alibaba
`deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu xenial stable`.

The GPG key can be fetched from `http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg`.

Same procedure is needed for Gitlab, replace the official
`deb https://packages.gitlab.com/gitlab/gitlab-ce/ubuntu/ xenial main` with
`deb https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu xenial main`
provided by https://mirror.tuna.tsinghua.edu.cn/ (I guess this is some
kind of school). The official key can be used for this repository.

I haven't found any need for other mirrors yet, but I'm sure there is a
need depending on which software you use.

## No Route53

Again, no surprise, Route53 isn't available in China. But, you can configure
Route53 with an AWS "world" account and use Route53 in China, since there are
edge nodes in China. You just can't access the API in China via `amazonaws.cn`.

## IAM isn't global

IAM is supposed to be global, which it almost is, except China. China has their
own installation of IAM, so you need to duplicate your users from AWS into AWS
China. Not a big issue, but something to be aware of.

## Final words

I think it's amazing that we can use AWS in China, even with the limitations
and caveats. I think there's still a lot for me to learn about China, so I'll
probably revisit this post at a later time and update it with new problems and
solutions.
