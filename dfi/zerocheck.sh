#!/bin/bash

 echo " _____           _____           ______               _____ _               _    "
 echo "|  __ \         / ____|         |___  /              / ____| |             | |   "
 echo "| |__) | __ ___| (___   ___  ___   / / ___ _ __ ___ | |    | |__   ___  ___| | __"
 echo "|  ___/ '__/ _ \\\\___ \ / _ \/ __| / / / _ \ '__/ _ \| |    | '_ \ / _ \/ __| |/ /"
 echo "| |   | | | (_) |___) |  __/ (__ / /_|  __/ | | (_) | |____| | | |  __/ (__|   < "
 echo "|_|   |_|  \___/_____/ \___|\___/_____\___|_|  \___/ \_____|_| |_|\___|\___|_|\_\\"
 echo ""

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

if [ -s /root/input/msf/ws.txt ] || [ /root/output/msf/zerohosts.txt ]; then
    echo '! >Workspace already set or zerohosts available!'
else
    read -p "Enter Workspace Name: " WS
    echo 'workspace -a ' $WS > /root/input/msf/ws.txt
    echo 'hosts -S Windows -c name,address -o /root/output/msf/zerohosts.txt' >> /root/input/msf/ws.txt
    echo 'exit' >> /root/input/msf/ws.txt
fi

if [ -s /root/output/list/zero.txt ]; then
    echo '! > list zero.txt available!'
else
    msfconsole -qx "resource /root/input/msf/ws.txt" > /dev/null
    awk '/\"/ {print}' /root/output/msf/zerohosts.txt | grep -v '""' | cut -d '"' -f 2,4 | sed 's/"/ /' > /root/output/list/zero.txt
fi

if [ -d /opt/CVE-2020-1472 ]; then
    echo '! > No Download nessesary.'
else
    cd /opt
    git clone https://github.com/SecuraBV/CVE-2020-1472.git /opt/CVE-2020-1472
    pip3 install -r /opt/CVE-2020-1472/requirements.txt
fi

if [ -s /root/output/list/zero.txt ]; then
    for i in $(cat /root/output/list/zero.txt); do
        python3 /opt/CVE-2020-1472/zerologon_tester.py $i >> /root/output/msf/zerologon.txt
    done
    echo '! > Check Done!'
else
    echo '! > Check not possible no Targets /root/output/list/zero.txt'
fi
