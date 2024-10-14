#!/bin/bash
# Kaiwan NB
name=$(basename $0)
ERRLOG=.errlog
usr=pi #ubuntu  #pi
# disable stict checking
sshopts="-o UserKnownHostsFile=/dev/null"  #"-v"

check_keyrm()
{
local pathnm="$1"
local warning_id_changed="@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @"

#cat ${ERRLOG}
# Is it the 'expected' warning?
grep -q "${warning_id_changed}" ${ERRLOG} && {
 # yes! delete the key and retry
 echo "${name}: deleting old key and retrying ..."
 local keygencmd=$(grep "^ *ssh-keygen -f" ${ERRLOG})
 [ ! -z "${keygencmd}" ] && eval "${keygencmd}" || exit 1
 exec ${pathnm}
 }
} # end check_keyrm()


### --- "main" here

[ $# -ge 1 -a "$1" = "-h" ] && {
  echo "Usage: ${name} [-s]
-s  : ONLY show the R Pi's IP address and exit
-st : attempt to connect over ssh to fixed static IP (in the code)
else, attempt to get R Pi's IPaddr and connect over ssh (login 'pi')"
  exit 0
}

# RPi w/ static IP setup
#SHORTCUT=0
#[ ${SHORTCUT} -eq 1 ] && {
[ $# -ge 1 -a "$1" = "-st" ] && {
  date
  echo "ssh -o UserKnownHostsFile=/dev/null pi@192.168.0.200"
  ssh -o UserKnownHostsFile=/dev/null pi@192.168.0.200
  date
  exit 0
}

which arp-scan >/dev/null 2>&1 || {
  echo "apr-scan not installed?"
  exit 1
}
rm -f ${ERRLOG} 2>/dev/null

# ONLY show R Pi's IP
[ "$1" = "-s" ] && {
 echo "${name}: ONLY fetching Raspberry Pi's IP address with arp-scan(1), pl wait ..."
 RPIIP=$(sudo arp-scan --localnet |grep -i -w raspberry |awk '{print $1}') #|head -n1)
 #RPIIP=$(sudo arp-scan --interface=wlp4s0 --localnet |grep -i -w raspberry |awk '{print $1}'|head -n1)
 [ -z "${RPIIP}" ] && {
  echo "Failed to fetch R Pi IP with arp-scan.."
  exit 1
 }
 echo "R Pi IP addr:
${RPIIP}"
 exit 0
}

echo "${name}: fetching Raspberry Pi's IP address with arp-scan(1), pl wait ..."
RPIIP=$(sudo arp-scan --localnet |grep -i -w raspberry |awk '{print $1}'|head -n1)
#RPIIP=$(sudo arp-scan --interface=wlp4s0 --localnet |grep -i -w raspberry |awk '{print $1}'|head -n1)
[ -z "${RPIIP}" ] && {
  echo "Failed to fetch R Pi IP with arp-scan.."
  exit 1
}

# Got the R Pi's IP addr
date
echo "ssh ${sshopts} ${usr}@${RPIIP}"
ssh ${sshopts} ${usr}@${RPIIP} |tee ${ERRLOG} 1>&2 || {
   # it failed
   #check_keyrm $0
   echo "ssh fail"
}
# ssh session done
date
