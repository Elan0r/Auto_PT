#!/bin/bash

figlet ProSecAutoPT
echo 'version 1.7 '

if [ -s /root/input/ipint.txt ]; then
  echo '! > IPs OK '
else
  echo '! >> ipint.txt is missing in /root/input/ipint.txt.'
  exit 1
fi

#Create all folder
/opt/auto_pt/scripts/folder.sh

read -r -p "Enter Workspace Name: " WS
echo 'workspace -d ' "$WS" >/root/input/msf/workspace.txt
echo 'workspace -a ' "$WS" >>/root/input/msf/workspace.txt
echo 'workspace ' "$WS" >/root/input/msf/ws.txt
echo 'db_import /root/output/nmap/service.xml' >>/root/input/msf/workspace.txt

tmux rename-window 'Auto_PT'

echo 'Start Auto_PT' >>/root/output/runtime.txt
date >>/root/output/runtime.txt
echo '! > Start Active Recon'
/opt/auto_pt/scripts/010-active_recon.sh

echo '! > Start Metasploit'
/opt/auto_pt/scripts/020-autosploit.sh

echo '! > Start Zerocheck'
/opt/auto_pt/scripts/030-zerocheck.sh

echo '! > Start Log4Check'
/opt/auto_pt/scripts/040-log4check.sh

echo '! > Start RPC 0 Check'
/opt/auto_pt/scripts/050-rpc0.sh

echo '! > Start Relay'
/opt/auto_pt/scripts/060-fast_relay.sh

echo "! > grab the loot!"
/opt/auto_pt/scripts/070-looter.sh

echo "! > Count the Loot!"
/opt/auto_pt/scripts/080-counter.sh

echo '! > make some Screens'
/opt/auto_pt/scripts/090-eyewitness.sh

echo '! > loot and count default Pages'
/opt/auto_pt/scripts/100-def_screen_looter.sh

figlet 'Auto PT Done'

echo "Finish PT" >>/root/output/runtime.txt
date >>/root/output/runtime.txt

exit 0
