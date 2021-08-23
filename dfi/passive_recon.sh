#!/bin/bash

if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

if [ -d /opt/PCredz ]; then
    echo '! > No Download nessesary.'
else
    git clone https://github.com/lgandx/PCredz.git /opt/
    apt install -y python3-pip libpcap-dev && pip3 install Cython python-libpcap
fi

tmux -f /opt/hacking/dfi/dfitmux.conf new-session -d
tmux rename-window 'Passive-Recon'

echo -e '' > /dev/pts/1
echo "  _____           _____           _____              _           _____                      " > /dev/pts/1
echo " |  __ \         / ____|         |  __ \            (_)         |  __ \                     " > /dev/pts/1
echo " | |__) | __ ___| (___   ___  ___| |__) |_ _ ___ ___ ___   _____| |__) |___  ___ ___  _ __  " > /dev/pts/1
echo " |  ___/ '__/ _ \\\\___ \ / _ \/ __|  ___/ _\` / __/ __| \ \ / / _ \  _  // _ \/ __/ _ \| '_ \ " > /dev/pts/1
echo " | |   | | | (_) |___) |  __/ (__| |  | (_| \__ \__ \ |\ V /  __/ | \ \  __/ (_| (_) | | | |" > /dev/pts/1
echo " |_|   |_|  \___/_____/ \___|\___|_|   \__,_|___/___/_| \_/ \___|_|  \_\___|\___\___/|_| |_|" > /dev/pts/1
echo '' > /dev/pts/1

tmux send 'netdiscover -L -i eth0 >> /root/output/netdiscover' ENTER
tmux split-window
tmux send 'python3 /opt/PCredz/Pcredz -i eth0 -c' ENTER
tmux split-window
tmux send 'tail --follow /root/output/netdiscover' ENTER
echo '! >'
echo '! > tmux a ;if you have the dfitmux.conf xD'
