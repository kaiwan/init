
# repo:
# https://github.com/kaiwan/init
# If on a Raspberry Pi, run
sudo raspi-config

# setup Localization (date), WiFi, etc..

#--- from LLKD book

sudo apt update
# minimally
sudo apt install gcc make perl git

# everything
sudo apt install fakeroot build-essential tar ncurses-dev tar xz-utils libssl-dev bc stress python3-distutils libelf-dev linux-headers-$(uname -r) bison flex libncurses5-dev util-linux net-tools linux-tools-$(uname -r) exuberant-ctags cscope sysfsutils gnome-system-monitor curl perf-tools-unstable gnuplot rt-tests indent tree pstree smem libnuma-dev numactl hwloc bpfcc-tools sparse flawfinder cppcheck tuna hexdump openjdk-14-jre trace-cmd virt-what

