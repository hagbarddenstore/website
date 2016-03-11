+++
date = "2016-03-11T00:35:09+01:00"
draft = false
title = "Using nginx to load balance microservices"
slug = "using-nginx-to-load-balance-microservices"
tags = [ "etcd", "skydns", "nginx", "load balance", "services", "service discovery" ]
categories = [ "infrastructure" ]
+++

How to load balance services with nginx, confd and etcd.

<!--summary-->

Imagine this, you have a bunch of services running on a machine, all is fine
and dandy. You have the occasional downtime when you upgrade a service to a new
version, but nothing you can't handle.

Then, out of nowhere, you get loads of traffic, you need to scale horizontally,
adding more servers to your cluster. Upgrading becomes harder, takes longer
and there's more downtime. 

You figure it's time to load balance your services, but how to do it in a way
that scales and is easy to manage?

Well, that's where nginx+confd+etcd comes into play.

The overall architecture is this, nginx handles the load balancing part, confd
updates nginx configuration based on values in etcd, and services update etcd
with their information.

This allows confd to reconfigure nginx whenever there's a change in etcd, thus
reconfiguring nginx in near realtime.

So, how do we set this up? Well, I'm assuming you have the services part
figured out already, so I'm gonna skip that part. So, onto how to get started
with etcd.

## Etcd

Etcd is a key-value database, with a simple HTTP API, allowing the services to
easily insert values.

Etcd is very easy to install, it's a matter of downloading an executable and
running it. You can also run it on Docker using the `quay.io/coreos/etcd`
image.

But we're gonna focus on the stand-alone binary, so, head to
https://github.com/coreos/etcd/releases/ and grab the latest stable release for
your OS.

The package should be installed on atleast 3 different server nodes, preferably
5, to provide failover. Installation is easy, just unzip and run the executable
by running the following command:

```
ETCD_DISCOVERY=$(curl https://discovery.etcd.io/new?size=3)

etcd --name $(hostname -s) \
     --initial-advertise-peer-urls http://10.0.0.1:2380 \
     --listen-peer-urls http://10.0.0.1:2380 \
     --listen-client-urls http://10.0.0.1:2379,http://127.0.0.1:2379 \
     --advertise-client-urls http://10.0.0.1:2379 \
     --discovery $ETCD_DISCOVERY
```

**NOTE:** The `ETCD_DISCOVERY` must be the same on all machines.

So, let's explain the parameters.

* **--name** = Name of the instance running etcd, this must be a within the
  cluster unique identifier. It's used by etcd to separate nodes apart. The
  hostname or machine id are good candidates.
* **--initial-advertise-url** = URL to advertise to other etcd nodes to allow
  internal etcd communication. The hostname or any IP address which other etcd
  nodes can reach are good values for this parameter.
* **--listen-peer-urls** = URL on which etcd listens for internal etcd
  communication. This should be the same value as `--initial-advertise-url` in
  most cases.
* **--listen-client-urls** = URLs on which etcd listens for client
  communication. This is the address you use to communicate with etcd.
  Preferably you want to add both `127.0.0.1` and a public IP, to allow both
  localhost communication and external clients.
* **--advertise-client-urls** = URLs which etcd advertises to the cluster. This
  could be the same as `--listen-client-urls` minus the localhost address.
* **--discovery** = URL to a discovery service, used by nodes to discover the
  cluster when no previous contact has been made. This value should be the same
  on all nodes you wish to include in the same cluster. You can get a new URL
  by running `curl https://discovery.etcd.io/new?size=3` where 3 is the
  minimum amount of nodes in the cluster. You need to have atleast 3 nodes in
  your cluster to make a highly available cluster. A size between 5 and 9 is
  recommended if you're running a cluster with high uptime requirements.

Now that we've got parameters covered, let's run the command on atleast 3
servers and you should have a functional etcd cluster up and running. You can
verify by running `curl http://localhost:2379/version` on one of the machines.

Next step is to setup nginx!

## Nginx

We're not gonna do any custom configuration on nginx, so a simple
`# apt-get install nginx` is sufficient if you're running a Debian-based OS.

With nginx running (Verify by running `curl http://localhost/`), let's move
on to the next step, which is installing and configuration confd!

## Confd

So, finally at the step which does all of the magic!

First things first, we need to install confd. Head over to
[Github](https://github.com/kelseyhightower/confd/releases) and get the latest
release (At the time of writing, latest is v0.12.0-alpha3), put it on your
nginx machines and unzip. Move the `confd` binary into `/usr/bin/confd`.

Next step is to create a configuration file for confd, a template and
optionally an init startup script.

### /etc/confd/conf.d/nginx.toml

This is the confd nginx configuration file, it tells confd where to find the
template file, where to place the result, which command to run on change and
what keys to watch.

```
[template]
src = "nginx.conf.tmpl"
dest = "/etc/nginx/sites-enabled/services.conf"
owner = "nginx"
mode = "0644"
keys = [
    "/services",
]
reload_cmd = "/usr/sbin/service nginx reload"
```

* **src** = Name of the template file to execute on each change.
* **dest** = Name of the file where the output of the template should be
  placed.
* **owner** = File owner of the dest file.
* **mode** = File mode of the dest file.
* **keys** = Etcd keys to watch for change. You can watch `/`, but to ignore
  keys you're not interested in, you should specify which keys you're
  interested in. You don't need to specify the full keys (That would defeat
  the point of this post!), but the static part in the beginning of the key, in
  this case `/service`.
* **reload_cmd** = Command to run after the template has run.

Put the above content in `/etc/confd/conf.d/nginx.toml`, then continue with
the next file.

### /etc/confd/templates/nginx.conf.tmpl

Ah, the template file!

I'm not gonna explain the content of this file, it's a mix between Go's
`text/template` markup and nginx's configuration file.

If you want to figure out the stuff between `{{` and `}}`, head over to
[Go's text/template](https://golang.org/pkg/text/template/) and
[confd template documentation](https://github.com/kelseyhightower/confd/blob/master/docs/templates.md).

```
{{ $services := ls "/services" }}
{{ range $service := $services }}
{{ $servers := getvs ( printf "/services/%s/servers/*" $service ) }}
{{ if $servers }}
upstream {{ $service }} {
  {{ range $server := $servers }}
  {{ $data := json $server }}
  server {{ $data.host }}:{{ $data.port }};
  {{ end }}
}
{{ end }}
{{ end }}

server {
  server_name hostname;
  
  {{ range $service := $services }}
  {{ $servers := getvs ( printf "/services/%s/servers/*" $service ) }}
  {{ if $servers }}
  location /{{ $service }} {
    rewrite /{{ $service }}/(.*) /$1 break;

    proxy_pass http://{{ $service }};
    proxy_redirect off;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forward-Proto $scheme;
  }
  {{ end }}
  {{ end }}
}
```

Copy and paste the above content into `/etc/confd/templates/nginx.conf.tmpl`.

### /etc/init/confd.conf

This step is optional and requires Upstart (Present on Ubuntu). Feel free to
adapt the script to other init systems. The main part is the last line, which
starts the confd daemon. Replace the `etcd-address` with the address to one
of the machines running etcd.

If you wish to this as a daemon, without Upstart, simply run
`/usr/bin/confd -backend etcd -watch -node http://etcd-address:2379/ &`.

```
description "confd daemon"

start on runlevel [12345]
stop on runlevel [!12345]

env DAEMON=/usr/bin/confd
env PID=/var/run/confd.pid

respawn
respawn limit 10 5

exec $DAEMON -backend etcd -watch -node http://etcd-address:2379/
```

If you went with the Upstart route, run `sudo service confd start`.

Onto the next step, we're almost done!

## Services

All of this did nothing! Calm your horses, we haven't added any services to
etcd yet!

This is quite simple though, simply execute

```
curl http://any-etcd-node:2379/v2/keys/services/$service_name$/servers/$hostname$ \
     -d value='{"host":"$public_ip$","port":$port$}' -d ttl=60 -X PUT
```

Replace `$service_name$` with the name of the service you wish to load balance,
replace $hostname$ with hostname or machine id of the instance running the
service, replace `$public_ip$` with the IP address on which the nginx
machine(s) can reach the service and lastly replace `$port$` with the port on
which the service is listening for incoming HTTP traffic.

Do note the `-d ttl=60` parameter, this tells etcd that it should delete the
value in 60 seconds, so you need to continuously execute the curl command to
keep the value in etcd. By doing this, you allow etcd to clean up services that
is no longer available. Tweak the number to suit your use cases. My
recommendation is to have a ttl of 60 and updating every 45 seconds. This
allows for some downtime if a service crashes, but it shouldn't affect things
that much, but as said, adjust to your use case.

When you stop your service, you need to delete the key (And stop the updating
script/routine!), this is done by running
`curl http://any-etcd-node:2379/v2/keys/services/$service_name$/servers/$hostname$ -X DELETE`
with the same values as the create script above. This tells etcd and confd that
the service is no longer avilable and should be removed ASAP. My recommendation
is to run this before you stop the service, as to hinder nginx from sending
requests to a service which no longer exists.

## Last words

This is it! I hope you enjoyed the post and that you'll find it useful to setup
your own highly available web applications.

Confd is by no means restricted to just configuring nginx, it can configure
pretty much anything, as long as the configuration is file based and there's a
reload/restart command available.

I like using nginx since I know it quite well and it's fast, mature and highly
reliable.

Got any questions? Ping me on [Twitter](https://twitter.com/hagbarddenstore) or
send me a message on [IRC](irc://irc.freenode.net/##csharp) where I go by the
name `Kim^J`.

