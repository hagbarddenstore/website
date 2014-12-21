+++
date = "2014-12-21T14:12:00+02:00"
draft = false
title = "Run a webserver in any folder on Mac OS X"
slug = "run-a-webserver-in-any-folder-on-mac-os-x"
tags = [ "mac os x", "python", "webserver", "tools", "tips and tricks", ]
+++

### Problem:

Hosting HTML files in a proper webserver on Mac OS X without having to install
something like Apache HTTPD or nginx and configure. I want the simplest
solution to get this up and running.

### Solution:

Run the following snippet and you'll have a working HTTP server hosting your
static content on port 8000.

    cd /path/to/my/folder
    python -m SimpleHTTPServer 8000

Credit goes to [Lifehacker](http://lifehacker.com/start-a-simple-web-server-from-any-directory-on-your-ma-496425450).