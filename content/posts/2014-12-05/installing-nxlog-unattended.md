+++
date = "2014-12-05T11:18:00+02:00"
draft = true
title = "Installing NXLog unattended"
slug = "installing-nxlog-unattended"
tags = [ "nxlog", ]
+++

TL;DR;

Install NXLog unattended on a Windows server via a PowerShell script.

<!--more-->

Today I created the task of installing nxlog on our servers to push logs to
Loggly and have Loggly index the logs to enable developers access to the logs.

Since we have no Remote Desktop access, we cannot use an installation which
requires us to "Click" on a button, so unattended install it is.

Since the nxlog manual doesn't mention unattended installation, I had to do some
research before doing the installation. Since it's an MSI-file we can invoke
some MSI magic to install it. The /qn parameter to msiexec tells it to not start
the GUI

### install-nxlog-unattended.ps1

    $installationPath = "C:\nxlog"

    New-Item -ItemType Directory -Force -Path $installationPath

    cd $installationPath

    $webClient = New-Object System.Net.WebClient

    $url = "http://optimate.dl.sourceforge.net/project/nxlog-ce/nxlog-ce-2.8.1248.msi"
    $file = "$installationPath\nxlog.msi"

    $webClient.DownloadFile($url, $file)

    msiexec /qn /l* nxlog-installation.log /i $file

    Start-Service nxlog