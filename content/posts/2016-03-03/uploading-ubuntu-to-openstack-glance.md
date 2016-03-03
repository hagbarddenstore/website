+++
date = "2016-03-03T16:28:00+01:00"
draft = false
title = "Uploading Ubuntu to Openstack Glance"
slug = "uploading-ubuntu-to-openstack-glance"
tags = [ "ubuntu", "glance", "openstack", ]
categories = [ "openstack", ]
+++

How to upload Ubuntu 14.04 to an Openstack provider.

<!--more-->

Run the following commands to download the latest Ubuntu 14.04 image and
upload it to the Openstack provider.

```
$ curl \
    -o trusty-server-cloudimg-amd64-disk1.img \
    http://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img

$ glance image-create \
    --architecture x86_64 \
    --name "ubuntu-14.04.4" \
    --min-disk 10 \
    --os-version 14.04.4 \
    --disk-format qcow2 \
    --os-distro ubuntu \
    --min-ram 1024 \
    --container-format bare \
    --file trusty-server-cloudimg-amd64-disk1.img \
    --progress
```

The instructions assume you have a properly configured Openstack environment
running on the computer where you run the above commands.
