#!/bin/bash

figlet ProSecZeroCheck
echo "with nmap"
if [ -d /root/output/nmap -a -d /root/output/list -a -d /root/input/msf -a -d /root/output/loot -a -d /root/output/msf ]; then
    echo '! > Folder Exist!'
else    
    #Creating Output Folders
    mkdir -p /root/output/nmap /root/output/list /root/input/msf /root/output/loot /root/output/msf
    #echo '! > Folder Created!'
fi

echo "Start zerocheck" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

#MSF Resource File
printf '%sspool /root/output/msf/zerologon.txt\necho "ZeroLogon"\nuse auxiliary/admin/dcerpc/cve_2020_1472_zerologon\n' > /root/input/msf/zerocheck.txt
paste /root/output/list/dc_ip.txt /root/output/list/dc_nbt.txt | awk '// {printf"\nset nbname "$2"\nset rhosts "$1"\ncheck\nsleep 5\n"}' >> /root/input/msf/zerocheck.txt
printf '%s\nexit\n' >> /root/input/msf/zerocheck.txt

echo "Start MSF Zerologon check" >> /root/output/runtime.txt
date >> /root/output/runtime.txt

msfconsole -qx "resource /root/input/msf/ws.txt /root/input/msf/zerocheck.txt" > /dev/null
echo '! > Zerologon Check Done!'

exit 0
