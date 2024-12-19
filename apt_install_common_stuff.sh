#!/bin/bash
# repo:
# https://github.com/kaiwan/init
name=$(basename $0)

die()
{
echo >&2 "FATAL: $@"
exit 1
}

# runcmd
# Parameters
#   $1 ... : params are the command to run
runcmd()
{
	[ $# -eq 0 ] && return
	echo "$@"
	eval "$@"
}


# On a Raspberry Pi, run
sudo raspi-config
     # setup Localization (date), WiFi, etc..

echo "${name}: update..."
sudo apt update

# minimally
echo "${name}: install minimal packages..."
sudo apt install -y gcc make perl git

#--- from LKP2E book
# packages typically required for kernel build
echo "${name}: install all required packages for kernel build..."
runcmd sudo apt install -y \
	asciidoc binutils-dev bison build-essential flex libncurses5-dev ncurses-dev \
	libelf-dev libssl-dev pahole tar util-linux xz-utils zstd

echo "-----------------------------------------------------------------------"

# other packages...
# TODO : check if reqd
#sudo apt install -y bc bpfcc-tools build-essential \

echo "${name}: install other packages..."
runcmd sudo apt install -y \
	bc bpfcc-tools bsdextrautils \
	clang cppcheck cscope curl exuberant-ctags \
	fakeroot flawfinder \
	git gnome-system-monitor gnuplot hwloc indent kexec-tools \
	libnuma-dev linux-headers-$(uname -r) linux-tools-$(uname -r) \
	man-db net-tools numactl openjdk-18-jre  \
	perf-tools-unstable psmisc python3-distutils  \
	raspberrypi-kernel-headers rt-tests smem sparse stress sysfsutils \
	tldr-py trace-cmd tree tuna vim virt-what yad

sync ; sleep 1
echo "sudo apt upgrade"
sudo apt upgrade

ZERO_SETUP=rpi/0setup_rpi.bash
echo "Setup for a Raspberry Pi board now? [y/n] "
read reply
[[ "${reply}" = "n" ]] && {
	echo "Setup for a TI BeagleBone Black (BBB) board now? [y/n] "
  	read reply
 	[[ "${reply}" = "y" ]] && ZERO_SETUP=bbb/0setup_bbb.bash
}

echo "${name}: installing ${ZERO_SETUP} and ~/.vimrc ..."
[[ -f ${ZERO_SETUP} ]] && {
	sudo cp ${ZERO_SETUP} /
	sudo chown ${USER}:${USER} ${ZERO_SETUP}
	# Append to ~/.bashrc to autorun every time a shell's spawned
	sed -i '$ a # Run our custom startup script\necho "source /0setup*"\nsource /0setup*' ~/.bashrc
}
[ -f dot_vimrc ] && cp dot_vimrc ~/.vimrc
