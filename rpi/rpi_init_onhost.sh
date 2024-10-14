#!/bin/bash
# rpi_init

[ $(id -u) -ne 0 ] && {
 echo "need root."
 exit 1
}

# NOTE !!! Assuming it's Raspberry Pi OS on the uSD card!
echo "NOTE !!! Assuming it's Raspberry Pi OS on the uSD card!
Press [Enter] or ^C"
read

df |grep -q "^/dev/mmcblk0p1.*boot$" || {
  echo "RPi OS uSD card (boot) not mounted?" ; exit 1
}
df |grep -q "^/dev/mmcblk0p2.*rootfs$" || {
  echo "RPi OS uSD card (rootfs) not mounted?" ; exit 1
}

BOOT=$(df |grep "^/dev/mmcblk0p1.*boot$" |awk '{print $6}')
ROOTFS=$(df |grep "^/dev/mmcblk0p2.*rootfs$" |awk '{print $6}')
echo "[+] Found partitions on uSD: ${BOOT} and ${ROOTFS}"

echo "[+] enabling SSH and WiFi"
# enable SSH
touch ${BOOT}/ssh
# setup WiFi
cat > ${BOOT}/wpa_supplicant.conf << @EOF@
country=IN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="khome-2.4"
    psk="tuxlinux18"
}
@EOF@


### TODO
# [1] ensure wpa_supplicant.conf has hashed / encrypted WiFi pswd
# https://carmalou.com/how-to/2017/08/16/how-to-generate-passcode-for-raspberry-pi.html 
# 	added the line ‘        key_mgmt=WPA-PSK ‘:

# $ cat /etc/wpa_supplicant/wpa_supplicant.conf
# ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
# update_config=1
# country=IN
# 
# network={
#         ssid="khome-2.4"
#         psk=2713... ... ...
#         key_mgmt=WPA-PSK
# }

# Reconfigure the interface with 
# wpa_cli -i wlan0 reconfigure

# setup static IP
echo "[+] enabling static IP for WiFi"
sudo cp ${ROOTFS}/etc/dhcpcd.conf ${ROOTFS}/etc/dhcpcd.conf.orig
sudo cat >> ${ROOTFS}/etc/dhcpcd.conf << @EOF@

# KNB: RPi init script, enable static IP
interface wlan0     # WIRELESS (WIFI)

static ip_address=192.168.1.200/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1
@EOF@

PFX=/big/Dropbox/DG_Work_Dropbox/
sudo cp ${PFX}/github_kaiwan_repos/init/0setup_rpi.bash ${ROOTFS}/home/pi/
sudo ln -sf ${ROOTFS}/home/pi/0setup_rpi.bash ${ROOTFS}/
sudo cat >> ${ROOTFS}/home/pi/.bashrc << @EOF@
# KNB
source /home/pi/0setup_rpi.bash
@EOF@
sudo cat >> ${ROOTFS}/root/.bashrc << @EOF@
# KNB
source /home/pi/0setup_rpi.bash
@EOF@
sync

echo "Done."
