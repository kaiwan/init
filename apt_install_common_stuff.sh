#!/bin/bash
# repo:
# https://github.com/kaiwan/init
name=$(basename $0)

# On a Raspberry Pi, run
sudo raspi-config
     # setup Localization (date), WiFi, etc..

echo "${name}: update..."
sudo apt update

# minimally
echo "${name}: install minimal packages..."
sudo apt install -y gcc make perl git

#--- from LKP book
echo "${name}: install all required packages..."
sudo apt install -y \
        bc bpfcc-tools bsdextrautils \
        cppcheck cscope curl exuberant-ctags \
        fakeroot file flawfinder \
        git gnome-system-monitor gnuplot hwloc indent \
        libnuma-dev man-db net-tools \
        perf-tools-unstable psmisc python3-distutils  \
        raspberrypi-kernel-headers rt-tests smem sparse stress sysfsutils \
        tldr-py trace-cmd tree tuna \
        util-linux vim virt-what xz-utils

echo "${name}: install 0setup_rpi.bash and ~/.vimrc ..."
[ -f 0setup_rpi.bash ] && sudo cp 0setup_rpi.bash /
# Append to ~/.bashrc to autorun every time a shell's spawned
sed -i '$ a # Run our custom startup script\n/source 0setup_rpi.bash' ~/.bashrc
[ -f dot_vimrc ] && cp dot_vimrc ~/.vimrc
