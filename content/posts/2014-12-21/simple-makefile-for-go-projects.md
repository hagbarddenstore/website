+++
date = "2014-12-21T14:25:00+02:00"
draft = false
title = "Simple Makefile for Go projects"
slug = "simple-makefile-for-go-projects"
tags = [ "makefile", "golang", ]
+++

So, I've recently started coding in Go and found that when moving projects
between different computers, it was a hassle to remember which dependencies I
needed to install, which commands did what, etc. So I created my own Makefile
which means I only need to remember "make", "make test" and "make run".

After some trial and errors, this is the Makefile I found to work well enough:

    all: project_name

    project_name: *.go subdirectory/*.go
        go build .

    clean:
        rm -rf project_name

    run:
        ./project_name

    test:
        go test ./... -v

    install_deps:
        go get -u github.com/user/package

### Disclaimer

I've just started working in Go, so this file is by all means not the perfect
Makefile out there for Go, it's just something I've fiddled with to get a
smooth experience working with Go projects.

If you have a better solution on how to handle this, please send me a Tweet
@hagbarddenstore