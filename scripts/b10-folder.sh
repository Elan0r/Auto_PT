#!/bin/bash

mkdir -p /root/input/msf
mkdir -p /root/output/msf
mkdir -p /root/output/list/ot
mkdir -p /root/output/nmap/ot
mkdir -p /root/output/scrying/vnc
mkdir -p /root/output/scrying/rdp
mkdir -p /root/output/loot/hashes
mkdir -p /root/output/loot/harvest
mkdir -p /root/output/loot/eol/ssh
mkdir -p /root/output/loot/eol/windows
mkdir -p /root/output/loot/eol/ssh_depricated
mkdir -p /root/output/loot/smb/eternal_blue
mkdir -p /root/output/loot/smb/smb_v1
mkdir -p /root/output/loot/smb/smb_signing
mkdir -p /root/output/loot/smb/anonymous_enumeration
mkdir -p /root/output/loot/smb/permission_management
mkdir -p /root/output/loot/smb/sensitive_information
mkdir -p /root/output/loot/database/mssql/login
mkdir -p /root/output/loot/database/postgresql/login
mkdir -p /root/output/loot/database/mssql/browser
mkdir -p /root/output/loot/database/mysql/login
mkdir -p /root/output/loot/database/mongodb/login
mkdir -p /root/output/loot/rpc/portmapper
mkdir -p /root/output/loot/rpc/endpointmap
mkdir -p /root/output/loot/rpc/amplification
mkdir -p /root/output/loot/rpc/zero_logon
mkdir -p /root/output/loot/rpc/print_nightmare
mkdir -p /root/output/loot/rpc/petit_potam
mkdir -p /root/output/loot/rpc/dfscoerce
mkdir -p /root/output/loot/rpc/shadowcoerce
mkdir -p /root/output/loot/rpc/null_sessions
mkdir -p /root/output/loot/rpc/nfs
mkdir -p /root/output/loot/rdp/bluekeep
mkdir -p /root/output/loot/rdp/nla
mkdir -p /root/output/loot/rdp/ms12-020
mkdir -p /root/output/loot/ad/kerberos/asreproast
mkdir -p /root/output/loot/ad/kerberos/delegation
mkdir -p /root/output/loot/ad/kerberos/kerberoasting
mkdir -p /root/output/loot/ad/kerberos/krbtgt
mkdir -p /root/output/loot/ad/kerberos/user_enum
mkdir -p /root/output/loot/ad/kerberos/passwd_spray
mkdir -p /root/output/loot/ad/session
mkdir -p /root/output/loot/ad/quota
mkdir -p /root/output/loot/ad/gpp_password
mkdir -p /root/output/loot/ad/gpp_autologin
mkdir -p /root/output/loot/ad/adcs/esc1
mkdir -p /root/output/loot/ad/adcs/esc2
mkdir -p /root/output/loot/ad/adcs/esc4
mkdir -p /root/output/loot/ad/adcs/esc6
mkdir -p /root/output/loot/ad/adcs/esc8
mkdir -p /root/output/loot/ad/adcs/esc11
mkdir -p /root/output/loot/ad/iam/laps
mkdir -p /root/output/loot/ad/iam/ntlm_auth
mkdir -p /root/output/loot/ad/iam/passpol
mkdir -p /root/output/loot/ad/iam/remote_login_local_admin
mkdir -p /root/output/loot/ad/iam/user_description
mkdir -p /root/output/loot/ad/iam/rights
mkdir -p /root/output/loot/ad/iam/user_as_pass
mkdir -p /root/output/loot/dns/amplification
mkdir -p /root/output/loot/dns/tunnel
mkdir -p /root/output/loot/dns/zone_transfer
mkdir -p /root/output/loot/dns/filter
mkdir -p /root/output/loot/ipmi/hashdump
mkdir -p /root/output/loot/ipmi/zero_cipher
mkdir -p /root/output/loot/mail/imap/unencrypted
mkdir -p /root/output/loot/mail/pop3/unencrypted
mkdir -p /root/output/loot/mail/smtp/open_relay
mkdir -p /root/output/loot/mail/smtp/sender_restriction
mkdir -p /root/output/loot/mail/smtp/starttls
mkdir -p /root/output/loot/mail/smtp/unencrypted_auth
mkdir -p /root/output/loot/mail/smtp/rdns
mkdir -p /root/output/loot/printer/extract
mkdir -p /root/output/loot/printer/access
mkdir -p /root/output/loot/mitm/arp
mkdir -p /root/output/loot/mitm/stp
mkdir -p /root/output/loot/mitm/hsrp
mkdir -p /root/output/loot/mitm/vrrp
mkdir -p /root/output/loot/mitm/ipv6
mkdir -p /root/output/loot/mitm/nbt_llmnr
mkdir -p /root/output/loot/mitm/routing
mkdir -p /root/output/loot/mitm/wpad
mkdir -p /root/output/loot/mitm/mdns
mkdir -p /root/output/loot/network/snmp
mkdir -p /root/output/loot/network/ftp/anonymous
mkdir -p /root/output/loot/network/ftp/unencrypted
mkdir -p /root/output/loot/network/telnet
mkdir -p /root/output/loot/network/egress_filtering
mkdir -p /root/output/loot/network/icmp
mkdir -p /root/output/loot/network/cdp
mkdir -p /root/output/loot/network/dtp
mkdir -p /root/output/loot/network/hps
mkdir -p /root/output/loot/network/lldp
mkdir -p /root/output/loot/network/stp
mkdir -p /root/output/loot/network/vtp
mkdir -p /root/output/loot/network/trunk
mkdir -p /root/output/loot/network/client_isolation
mkdir -p /root/output/loot/network/other_protocols
mkdir -p /root/output/loot/network/clear_text
mkdir -p /root/output/loot/network/segmentation_segregation
mkdir -p /root/output/loot/network/ssh
mkdir -p /root/output/loot/vmware/vsan
mkdir -p /root/output/loot/vmware/vmdir
mkdir -p /root/output/loot/vmware/ova
mkdir -p /root/output/loot/vmware/vrops
mkdir -p /root/output/loot/vmware/ceip
mkdir -p /root/output/loot/vmware/log4shell
mkdir -p /root/output/loot/voip/h323
mkdir -p /root/output/loot/voip/sip
mkdir -p /root/output/loot/voip/rtp
mkdir -p /root/output/loot/ldap/signing
mkdir -p /root/output/loot/ldap/nopac
mkdir -p /root/output/loot/ldap/channel_binding
mkdir -p /root/output/loot/creds/lantronix
mkdir -p /root/output/loot/creds/bmc
mkdir -p /root/output/loot/creds/network
mkdir -p /root/output/loot/creds/phone
mkdir -p /root/output/loot/creds/printer
mkdir -p /root/output/loot/creds/ups
mkdir -p /root/output/loot/creds/san
mkdir -p /root/output/loot/creds/web
mkdir -p /root/output/loot/creds/mssql
mkdir -p /root/output/loot/creds/postgresql
mkdir -p /root/output/loot/creds/mysql
mkdir -p /root/output/loot/web/ilo
mkdir -p /root/output/loot/web/iis_bypass
mkdir -p /root/output/loot/web/ms15-034
mkdir -p /root/output/loot/web/httpd
mkdir -p /root/output/loot/web/iis
mkdir -p /root/output/loot/web/tomcat
mkdir -p /root/output/loot/web/jboss
mkdir -p /root/output/loot/web/services
mkdir -p /root/output/loot/web/index
mkdir -p /root/output/loot/web/php
mkdir -p /root/output/loot/web/nginx
mkdir -p /root/output/loot/web/iis_tilde
mkdir -p /root/output/loot/web/tls/heartbleed
mkdir -p /root/output/loot/web/log4shell
mkdir -p /root/output/loot/monitoring/ids_ips
mkdir -p /root/output/loot/mail/log
mkdir -p /root/output/loot/web/header/raw
mkdir -p /root/output/loot/msf
mkdir -p /root/output/loot/web/slowhttp/raw
mkdir -p /opt/PCredz/logs
