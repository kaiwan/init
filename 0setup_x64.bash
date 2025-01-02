#!/bin/bash
# 0setup.bash
# Convenience startup script
# Place this line in your ~/.bashrc (or ~/.bash_profile) to have this script
# auto-run login or when a terminal window is opened:
# source /0setup.bash
# (c) kaiwanTECH

red_highlight()
{
        [[ $# -eq 0 ]] && return
        echo -e "\e[1m\e[41m$1\e[0m"
}

open_execsnoop_window()
{
     gnome-terminal --window --title "execsnoop: all cmds (tail -f ${LOG})" \
  		  --geometry=200x16+100-50 --hide-menubar --zoom=0.75 \
  		  -- tail -f ${LOG}
}

script_rec()
{
# Start up a recording session via 'script' !
# Um, we can't... why? as it'smeant to be interactive... 
# it forks off a sub-shell within which the session is recorded..
#
# To RECORD a session:
#  script -s <transcript-file> -t <timing-file>
#
# So, just show the record log filename to use here...
SCRIPT_REC_DIR=/home/${USER}/script_rec
SCRIPT_REC="script ${SCRIPT_REC_DIR}/knb_session_$(date +%a_%d-%m-%y_%H%M).log --timing=${SCRIPT_REC_DIR}/knb_session_$(date +%a_%d-%m-%y_%H%M).timing"
echo "For script:

${SCRIPT_REC}

(Simply copy-paste the above command to begin a recording session.
To play it back:
  scriptreplay <transcript-file> -t <timing-file>
)
"
# 
# To VIEW the recorded transcript:
#  scriptreplay <transcript-file> -t <timing-file>
#
#  scriptreplay ${SCRIPT_REC_DIR}/knb_session_$(date +%a_%d-%m-%y_%H%M).log --timing=${SCRIPT_REC_DIR}/knb_session_$(date +%a_%d-%m-%y_%H%M).timing"
}


#--- 'main'

pushd . >/dev/null
#script_rec

USR=kaiwan    ### Keep UPDATED ###
export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/share/bcc/tools:/home/${USR}/pcloud/DG_Work_Dropbox/github_kaiwan_repos/usefulsnips/:/home/${USR}/pcloud/DG_Work_Dropbox/github_kaiwan_repos/show_gcc_switches:~/gitLinux/trccmd/:~/yocto_tools:~/github_kaiwan_repos/trccmd/:~/github_kaiwan_repos/procmap/:/usr/games
# x86_64-to-Aarch64 toolchain
export PATH=${PATH}:~/Downloads/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu/bin/
export PATH=${PATH}:/big/kernels/bb-kernel/dl/gcc-10.5.0-nolibc/arm-linux-gnueabi/bin/
export PATH=${PATH}:/big/scratchpad/kernel-hardening-checker/bin/
export PATH=${PATH}:~/Downloads/platform-tools  # adb, ...
# temp; for x86-64-to-aarch64 toolchain (yocto, kenix, for setcap; CROSS_COMPILE=aarch64-kaiwanTECH-linux-)
export PATH=${PATH}:/big/kenix_yocto/poky/build/tmp-glibc/work/raspberrypi4_64-kaiwanTECH-linux/u-boot/2024.01/recipe-sysroot-native/usr/bin/aarch64-kaiwanTECH-linux/

gsettings set org.gnome.mutter edge-tiling false

# prevent curl failing with '... error setting certificate verify locations...'
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# temperature on x64 (?)
t=$(cat /sys/class/hwmon/hwmon1/temp1_input)
printf "Temperature is %d.%dC\n" $((t/1000)) $((t%1000))

# Turn off all denials from the snap sandbox for all apps
# ref: https://askubuntu.com/a/1443608/245524
[[ $(id -u) -eq 0 ]] && {
 sh -c "echo -n quiet_denied > /sys/module/apparmor/parameters/audit"
 # Workaround for Yocto bitbake in U 24.04
 apparmor_parser -R /etc/apparmor.d/unprivileged_userns
}

# Uptime within 1 hour?
SHORT_UPTM=0
uptime -p|grep "hour" >/dev/null || SHORT_UPTM=1
uptime -p|grep "day" >/dev/null && SHORT_UPTM=0
[ ${SHORT_UPTM} -eq 1 ] && date

# Ubuntu screen blanks issue (after 30s idle); sol:
#xset -dpms

# Load & setup our USB laser pointer device if it's present
[ ${SHORT_UPTM} -eq 1 ] && {
  echo ">>> USB Laser Pointer device setup"
  # UPDATE path as reqd
  /home/kaiwan/gitL3/usb/laser_prsnt_input_usb/run_laserp
}

# tmp:
# Yocto RPi ZeroW 32-bit x86_64-to-ARM toolchain:
PATH=${PATH}:/big/yocto_seccam_rpi0w/poky/build_rpi0w/tmp/work/raspberrypi0_wifi-poky-linux-gnueabi/core-image-base/1.0-r0/recipe-sysroot-native/usr/bin/

# tc: just install the ARM-32 tc for R Pi by: sudo apt install crossbuild-essential-armhf
#PATH=${PATH}:/home/${USR}/big/Dropbox/DG_Work_Dropbox/toolchain/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf/bin
PATH=${PATH}:~/gitLinux_repos/usefulsnips/pvt
PATH=${PATH}:~/gitLinux/procmap
# Linaro gcc 10 x86_64-to-Aarch32 toolchain, 18 Dec '20 (!)
PATH=${PATH}:/big/scratchpad/SEALS_staging/gcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/bin
BASH_ENV=$HOME/.bashrc
PATH=${PATH}:~/.local/bin  # for ravioli

# ARM Aarch64 toolchain [https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads]
PATH=${PATH}:/big/scratchpad/gcc-arm-10.2-2020.11-x86_64-aarch64-none-linux-gnu/bin

# override toolchain to R Pi's - for LLKD book testing... these tc's are now DEPRECATED
#PATH=~/rpi_work/rpi_32bit/rpi_tools/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/:${PATH}
#PATH=${PATH}:/xtra/rpi_work/rpi_32bit/rpi_tools/tools/arm-bcm2708/arm-linux-gnueabihf/bin/

# Aliases
alias cl='clear'
alias ls='ls -F --color=auto'
alias l='ls -lFh --color=auto'
alias ll='ls -lF --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

#alias dmesg='sudo dmesg --color'
alias dmesg='sudo dmesg --decode --nopager --color --ctime'
alias dm='sudo dmesg --decode --color=always -x|tail -n35'
alias dc='echo "Clearing klog"; sudo dmesg -c > /dev/null'
alias lsh='lsmod | head'

alias grep='grep --color=always'
alias s='echo "Syncing.."; sync; sync; sync'
alias d='date; df -hT|head -n1;df -hT|grep "^/dev/" | grep -v " /snap/"'
 # use df -ih to see inode usage
#alias d='df -h|grep "^/dev/"'
alias f='free -ht'
alias ma='mount -a; df -h'

#--- journalctl aliases
export SYSTEMD_PAGER=cat  # no pager !
# jlog: current boot only, everything
alias jlog='/bin/journalctl -b --all --catalog --no-pager'
# jlogr: current boot only, everything, *reverse* chronological order
alias jlogr='/bin/journalctl -b --all --catalog --no-pager --reverse'
# jlogall: *everything*, all time; --merge => _all_ logs merged
alias jlogall='/bin/journalctl --all --catalog --merge --no-pager'
# jlogf: *watch* log, 'tail -f' mode
alias jlogf='journalctl -f'
# jlogk: only kernel messages, this boot
alias jlogk='journalctl -b -k --no-pager'
# show today's errors/fail/fatal messages
alias jlog_err_today="journalctl --no-pager --since today --grep 'fail|error|fatal' | sort | uniq -c | sort --numeric --reverse --key 1"
# show today's errors/fail/fatal messages in JSON format
alias jlog_err_today_json="journalctl --no-pager --since today \
--grep 'fail|error|fatal' --output json|jq '._EXE' | \
sort | uniq -c | sort --numeric --reverse --key 1"


alias py='ping -c3 yahoo.com'
alias inet='netstat -a|grep ESTABLISHED'
alias ifw='/sbin/ifconfig wlan0'
#--------------------ps stuff
# custom recent ps
alias rps='ps -o user,pid,rss,stat,time,command -Aww |tail -n30'
# custom ps sorted by highest CPU usage
alias rcpu='ps -o %cpu,%mem,user,pid,rss,stat,time,command -Aww |sort -k1n'
alias pscpu='ps aux|sort -k3n'
#--- perf
alias ptop='sudo perf top --sort pid,comm,dso,symbol 2>/dev/null'
alias ptopv='sudo perf top -r 80 -f 99 --sort pid,comm,dso,symbol \
--demangle-kernel -v --call-graph dwarf,fractal 2>/dev/null'
perfclasses()
{
sudo perf list | awk -F: '/Tracepoint event/ { lib[$1]++ } END {for (l in lib) { printf "  %-16s %d\n", l, lib[l] } }' | sort | column
}

alias logsys='ls -lh $(realpath ~/log_syshealthmon)'
#alias sudo='sudo env "PATH=$PATH"'
#------------------------------------------------------------------------------

#alias db='dropbox status'
#alias dbprogress='while [ true ]; do date; db; d|grep nvme0n1p4; sleep 300; done'
#alias vim='vim $@ >/dev/null 2>&1'
#alias vimc='vim *.[ch] Makefile *.sh'

alias tcpsvr='netstat lpn|grep tcp'

alias ssh='ssh -o IdentitiesOnly=yes -o StrictHostKeyChecking=no'
alias scp='scp -o IdentitiesOnly=yes -o StrictHostKeyChecking=no'

alias ssh='ssh -o IdentitiesOnly=yes -o StrictHostKeyChecking=no'
alias scp='scp -o IdentitiesOnly=yes -o StrictHostKeyChecking=no'
alias ssh2bbb='ssh debian@192.168.7.2'   # over USB0 as n/w intf!

alias sai='sudo apt install $*'
alias sdi='sudo dnf install $*'

#----------------------- Git ! ----------------------------------------
alias gdiff='git diff -r'
alias gfiles='git diff --name-status -r'
alias gstat='git status ; echo ; git diff --stat -r'
alias giturl='git remote get-url --all origin'
alias gitlog='git log --graph --pretty=format:"%h: %ar: %s" --abbrev-commit'
 #git log --graph --pretty=oneline --abbrev-commit'
alias gitls='git ls-files -s'

git config --global pull.rebase false  # merge (the default strategy)
# auth
git config --global credential.helper 'cache --timeout 86400'  # in sec; thus, 24 hrs
git config --global help.autocorrect 20

# Apr2024: setting up git send-email
# tut ref: https://git-send-email.io/
#git config --global sendemail.smtpPass 'rygklnodmntiosgo'
#----------------------------------------------------------------------

export BASH_ENV PATH
unset USERNAME

alias kmemleak_scan='sudo sh -c "echo scan > /sys/kernel/debug/kmemleak"'
alias kmemleak_show='sudo sh -c "cat /sys/kernel/debug/kmemleak"'

#--- Prompt
# ref: https://unix.stackexchange.com/questions/20803/customizing-bash-shell-bold-color-the-command
###
# NOTE!
# Using oh-my-git changes the prompt when in a git repo ! pretty cool/annoying !?
#  https://github.com/arialdomartini/oh-my-git
# can disable: rm -rf ~/.oh-my-git
#  or rm the line
#   source /home/kaiwan/.oh-my-git/prompt.sh
# in ~/.bashrc
#
# The symbols used by oh-my-git ::
# : ${omg_is_a_git_repo_symbol:='❤'}
# : ${omg_has_adds_symbol:='+'}                <-- files are staged
# : ${omg_has_untracked_files_symbol:='∿'}     <-- AKA the drop-of-blood
# : ${omg_has_deletions_symbol:='-'}
# : ${omg_has_cached_deletions_symbol:='✖'}
# : ${omg_has_modifications_symbol:='✎'}
# : ${omg_has_cached_modifications_symbol:='☲'}
# : ${omg_ready_to_commit_symbol:='→'}
# : ${omg_is_on_a_tag_symbol:='⌫'}
###
[ $(id -u) -eq 0 ] && {
   export PS1='|\W # '
   #export PS1='# '
   #export PS1='\[\e[1;34m\] $(hostname) # \[\e[0;32m\]'
   echo 1 > /proc/sys/kernel/oops_all_cpu_backtrace
} || {
   export PS1='|\W $ '
   #export PS1='\[\e[1;34m\] $(hostname) \$ \[\e[0;32m\]'
}
#trap 'printf \\e[0m' DEBUG  # IMP: turn Off color once Enter pressed..


#----------------------------------------------------------------------
# Aliases: now all are in ~/.bash_aliases
#  Checked for and sourced by ~/.bashrc
# But... when root, do it manually (didn't work otherwise)
#[ $(id -u) -eq 0 ] && source /home/kaiwan/.bash_aliases
#----------------------------------------------------------------------

popd >/dev/null

alias sd='sudo -s'
#alias sd='sudo /bin/bash'
alias see='date; w|head -n1; echo "syncing ..." ; sync'

[ $(id -u) -eq 0 ] && {
  # console debug: show all printk's on the console
  [ `id -u` -eq 0 ] && echo -n "7 4 1 7" > /proc/sys/kernel/printk
  # better core pattern
  [ ${SHORT_UPTM} -eq 1 ] && [ $(id -u) -eq 0 ] && {
   # first set fs.suid_dumpable to 1 - debug mode
   # ref: https://www.kernel.org/doc/html/latest/admin-guide/sysctl/fs.html#suid-dumpable
   echo 1 > /proc/sys/fs/suid_dumpable
   echo "corefile:host=%h:gPID=%P:gTID=%I:ruid=%u:sig=%s:exe=%E" > /proc/sys/kernel/core_pattern
  }
  #mount |grep -q "^/dev/sda3" || sudo mount /dev/sda3 /mnt/win7
}

[ ${SHORT_UPTM} -eq 1 ] && {
  grep "^PRETTY_NAME" /etc/os-release |cut -d"=" -f2
  cat /proc/version
  echo "Fetching kernel rel ..."
  curl -L https://www.kernel.org/finger_banner
}

# https://www.quora.com/What-is-the-most-useful-bash-script-that-you-have-ever-written
# The weather report, anyone?
[ 0 -eq 1 ] && {
echo "
The weather report, anyone?"
curl -s "wttr.in/$1?m1"
}

##-- netconsole !
# DUT 1: R Pi 3B+ SDcard where it's setup (Raspbian 10, 5.4.51-v7+)
# invoked on the DUT with:
#  sudo modprobe netconsole netconsole=@/wlan0,6661@192.168.1.101/
#  dest port # is 6661; no '-p' option switch!
# -d: don't read from stdin; reqd when running it in background mode!
#if [ ! -f ~/.netcat_rpi ] ; then
#  local LOG=~/rpi/klog_netconsole_rpi.txt
#  touch ~/.netcat_rpi
#  echo "
#----------------------------------------------
#$(date)
#----------------------------------------------" >> ${LOG}
#  netcat -d -u -l 6661 >> ${LOG} 2>&1 &
#fi

#--- DUT 2
 ## now runs as a root cron job ! ##
# Src: this native x86_64 (Dell Precision 7550) laptop
# Dest : Raspberry Pi Zero W
#  (look for the log on it).
#lsmod |grep -q netconsole || {
#  sudo netconsole-setup 192.168.1.200
#  [ $? -eq 0 ] && echo "netconsole [this sys-->RPi0W] loaded up"
#}

### Remote Monitoring project !
 ## now runs as a root cron job ! ##
# here: Dropbox/DG_Work_Dropbox/rmtmon
# sends journalctl -f o/p to the remote (RPi0W) system
#pgrep sendlogs >/dev/null || {
 # req sshkeys on remote sys for non-interactive login
#  ~/Dropbox/DG_Work_Dropbox/rmtmon/sendlogs.sh
#}

[ ${SHORT_UPTM} -eq 1 ] && {
  #--- 8-)
  hour=$(date +%H)
  if [ ${hour} -ge 4 -a ${hour} -le 11 ]; then
   tm="morning"
  elif [ ${hour} -ge 12 -a ${hour} -le 16 ]; then
   tm="afternoon"
  elif [ ${hour} -ge 17 -a ${hour} -le 19 ]; then
   tm="evening"
  else
   tm="night"
  fi
  toilet -F metal -f pagga.tlf "Good ${tm}, ${USER}!"
}
#---


[ ${SHORT_UPTM} -eq 1 ] && {
  hostnamectl
  [ $(id -u) -eq 0 ] && cowsay "CAREFUL! Logged in as root"
  # Ubunto logo with stats !
  echo "neofetch:"
  neofetch --color_blocks off --ascii "$(fortune | cowsay -W 30)"
  #/usr/bin/neofetch
  # v slow... (runs rpm?)

  echo "--- Last 10 system boots"
  journalctl --list-boots |tail
}

# execsnooper: it's now run via systemd at boot; 
# spawn a Terminal window to display commands as they're executed
LOG=/home/${USER}/all_commands_log.txt
# Check whether the small terminal window's already running
# (hey, |grep [t]ail ... to exclude grep from the command o/p!
#  ref: https://www.baeldung.com/linux/grep-exclude-ps-results )
ps -ef|grep "[t]ail -f .*all_commands_log.txt" >/dev/null 2>&1 || open_execsnoop_window

export EDITOR=vim

#-- last cmd:
#/bin/bash

###
# Some useful functions
###
function bpfccshow()
{
dpkg -L bpfcc-tools |grep "^/usr/sbin.*bpfcc$"|cut -d/ -f4|tr "\n" " "
}

function mem()
{
 echo "PID    RSS    WCHAN            NAME"
 ps -eo pid,rss,wchan:16,comm |sort -k2n
 echo
 echo "Note: 
 -Output auto-sorted by RSS (Resident Set Size)
 -RSS is expressed in kB!"
}

# dtop: useful wrapper over dstat
dtop()
{
DLY=5
echo dstat --time --top-io-adv --top-cpu --top-mem ${DLY}
 #--top-latency-avg
dstat --time --top-io-adv --top-cpu --top-mem ${DLY}
 #--top-latency-avg
}

#----------------- Git funcs -------------------------------------------
# shortcut for git SCM;
# -to add a file(s) and then commit it with a commit msg
function gitac()
{
 [ $# -ne 2 ] && {
  echo "Usage: gitac filename \"commit-msg-thats-well-thought-out\""
  return
 }
 echo "git add $1 ..."
 git add $1
 echo "git commit -m ..."
 git commit -m "$2"
 #git commit -S -m "$2"
  # -S : sign the commit; see https://stackoverflow.com/a/62933851/779269
  # u need to setup the GPG key (have done so)
}

function gitbranch()
{
 echo "curr branch: " ; git branch
 [ $# -ne 1 ] && {
  echo "Usage: gitbranch <new-branch-off-main>"
  return
 }
 #echo "git checkout -b $1 main ..."
 #git checkout -b $1 main
 echo "git checkout -b $1 master ..."
 git checkout -b $1 master
}

function gitmergebr()
{
 [ $# -ne 1 ] && {
  echo "Usage: gitmergebr <branch-to-merge-into-main>"
  return
 }
 echo "git checkout main && git merge $1 ..."
 git checkout main && git merge $1
}

function gitfilelog()
{
git log -p -- $@
}
#----------------- Misc funcs ------------------------------------------

# Show thread(s) running on cpu core 'n'  - func c'n'
function c0()
{
ps -eLF |awk '{ if($5==0) print $0}'
}
function c1()
{
ps -eLF |awk '{ if($5==1) print $0}'
}
function c2()
{
ps -eLF |awk '{ if($5==2) print $0}'
}
function c3()
{
ps -eLF |awk '{ if($5==3) print $0}'
}

#----- Src: https://www.quora.com/What-is-the-most-useful-bash-script-that-you-have-ever-written
function count() {
  total=$1
  for ((i=total; i>0; i--)); do sleep 1; printf "Time remaining $i secs \r"; done
  echo -e "\a"
}

# Extract many files with one command
function extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.tar.xz)    tar Jxvf $1    ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       rar x $1       ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip -d `echo $1 | sed 's/\(.*\)\.zip/\1/'` $1;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "don't know how to extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

# psd: ps with details
psd() 
{
    [ $# -eq 0 ] && {
	   ps -Aefwww
	   return
	}
    ps -Aefwww | grep --color=auto "$@"
}


# end 0setup.bash
