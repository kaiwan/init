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

RPI=0
BBB=0
X64=0
setup_0setup()
{
ZERO_SETUP=0setup_x64.bash
echo -n "Setup for a Raspberry Pi board now? [y/n] "
read reply
if [[ "${reply}" = "y" ]] ; then
   RPI=1
   ZERO_SETUP=rpi/0setup_bbb.bash
elif [[ "${reply}" = "n" ]] ; then
	echo -n "Setup for a TI BeagleBone Black (BBB) or BeaglePlay board now? [y/n] "
  	read reply
 	[[ "${reply}" = "y" ]] && {
	   BBB=1
	   ZERO_SETUP=bbb/0setup_bbb.bash
	} || X64=1
fi

echo "FYI: RPI=${RPI} BBB=${BBB} X64=${X64}
Press [Enter] to continue, ^C to abort..."
read

echo "${name}: installing ${ZERO_SETUP} and ~/.vimrc ..."
[[ -f ${ZERO_SETUP} ]] && {
	sudo cp ${ZERO_SETUP} /
	sudo chown ${USER}:${USER} ${ZERO_SETUP}
	# Append to ~/.bashrc to autorun every time a shell's spawned
	sed -i '$ a # Run our custom startup script\necho "source /0setup*"\nsource /0setup*' ~/.bashrc
}
[[ -f dot_vimrc ]] && cp dot_vimrc ~/.vimrc
}


#--- 'main'

setup_0setup

# On a Raspberry Pi, run
[[ ${RPI} -eq 1 ]] && sudo raspi-config
     # setup Localization (date), WiFi, etc..

echo "_______________________________________________________________________"
echo "${name}: update..."
sudo apt update

# minimally
echo "_______________________________________________________________________"
echo "${name}: install minimal packages..."
sudo apt install -y gcc make perl git

#--- from LKP2E book
# packages typically required for kernel build
echo "_______________________________________________________________________"
echo "${name}: install all required packages for kernel build..."
runcmd sudo apt install -y \
	asciidoc binutils-dev bison build-essential flex libncurses5-dev ncurses-dev \
	libelf-dev libssl-dev pahole tar util-linux xz-utils zstd

sync ; sleep 1
echo "sudo apt upgrade"
sudo apt upgrade


# Other packages...
# TODO : check if reqd
#sudo apt install -y bc bpfcc-tools build-essential \

echo ">> These are the other/misc pkgs:
	bc bpfcc-tools bsdextrautils \
	clang cppcheck cscope curl exuberant-ctags \
	fakeroot flawfinder \
	git gnome-system-monitor gnuplot hwloc indent kexec-tools \
	libnuma-dev linux-headers-$(uname -r) linux-tools-$(uname -r) \
	man-db net-tools numactl openjdk-18-jre  \
	perf-tools-unstable psmisc python3-distutils  \
	raspberrypi-kernel-headers rt-tests smem sparse stress sysfsutils \
	tldr-py trace-cmd tree tuna vim virt-what yad
"
echo ">> Install these other/misc packages? [y/n] "
read ans
[[ "${ans}" != "y" ]] && {
  sync ; echo "Done"
  exit 0
}

echo "_______________________________________________________________________"
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

sync ; echo "Done"
exit 0
