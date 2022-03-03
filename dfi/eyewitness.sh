#!/bin/bash

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

if [ -d /root/output/screens ]; then
    echo '! > Folder exist; mv screens screens_old for Backup purpose!'
    mv /root/output/screens /root/output/screens_old
    mkdir -p /root/output/screens
else    
    #Creating Output Folders
    mkdir -p /root/output/screens
    # echo '! > Folder created!'
fi

echo "Start Eyewitness" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

eyewitness --web --timeout 20 --delay 20 --no-prompt --prepend-https -x /root/output/nmap/service.xml -d /root/output/screens/

exit 0
