#!/bin/sh

cp vm-automation /usr/bin
cp vm-service /etc/init.d/

sudo update-rc /etc/init.d/vm-service defaults
