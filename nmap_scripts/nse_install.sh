#!/bin/bash

cp /opt/hacking/nmap_scripts/*.nse /usr/share/nmap/scripts/

#vulscan
if [ -d /opt/nmap-vulners ]; then
    cd /opt/nmap-vulners
    git stash
    git pull
else
    cd /opt
    git clone https://github.com/vulnersCom/nmap-vulners.git
fi
cp /opt/nmap-vulners/vulners.nse /usr/share/nmap/scripts/
cp /opt/nmap-vulners/http-vulners-regex.nse /usr/share/nmap/scripts/
cp /opt/nmap-vulners/http-vulners-regex.json /usr/share/nmap/nselib/data/
cp /opt/nmap-vulners/http-vulners-paths.txt /usr/share/nmap/nselib/data/
nmap --script-updatedb

exit0
