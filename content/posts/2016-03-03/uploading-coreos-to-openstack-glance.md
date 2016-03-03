+++
date = "2016-03-03T16:27:00+01:00"
draft = false
title = "Uploading CoreOS to Openstack Glance"
slug = "uploading-coreos-to-openstack-glance"
tags = [ "coreos", "glance", "openstack", ]
categories = [ "openstack", ]
+++

How to upload CoreOS to an Openstack provider.

<!--more-->

Run the following commands to download the latest CoreOS image and upload it
to the Openstack provider.

```
$ curl \
    -o coreos_production_openstack_image.img.bz2 \
    http://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2

$ bunzip2 coreos_production_openstack_image.img.bz2

$ glance image-create \
    --architecture x86_64 \
    --name "coreos" \
    --min-disk 10 \
    --disk-format qcow2 \
    --min-ram 1024 \
    --container-format bare \
    --file coreos_production_openstack_image.img \
    --progress
```

The instructions assume you have a properly configured Openstack environment
running on the computer where you run the above commands.
