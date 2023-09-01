#!/bin/bash
# 0setup_rpi.bash
# Convenience startup script for the Raspberry Pi
#
# You must run this as:
# $ . /0setup_rpi.bash
# or, better, put this as the last line of ~/.bashrc
#
# (c) kaiwanTECH
PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin:/home/${USER}/kaiwanTECH/usefulsnips
BASH_ENV=$HOME/.bashrc

export BASH_ENV PATH
unset USERNAME

#--- Prompt
# ref: https://unix.stackexchange.com/questions/20803/customizing-bash-shell-bold-color-the-command
[ `id -u` -eq 0 ] && {
   export PS1='\W # '
   #export PS1='\[\e[1;34m\] $(hostname) # \[\e[0;32m\]'
} || {
   export PS1='\W $ '
   #export PS1='\[\e[1;34m\] $(hostname) \$ \[\e[0;32m\]'
}
#trap 'printf \\e[0m' DEBUG  # IMP: turn Off color once Enter pressed..

echo "CPU temp (milliC): $(cat /sys/class/hwmon/hwmon0/temp1_input)"

# Aliases
alias cl='clear'
alias ls='ls -F --color=auto'
alias l='ls -lFh --color=auto'
alias ll='ls -lF --color=auto'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

#alias dmesg='/bin/dmesg --decode --nopager --color --ctime'
alias dm='sudo dmesg --color=always|tail -n35'
alias dc='echo "Clearing klog"; dmesg -c > /dev/null'
alias lsh='lsmod | head'

alias grep='grep --color=always'
alias s='echo "Syncing.."; sync; sync; sync'
alias d='df -h|grep "^/dev/"'
alias f='free -ht'
alias ma='mount -a; df -h'

#--- journalctl aliases
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

alias py='ping -c3 yahoo.com'
alias inet='netstat -a|grep ESTABLISHED'
alias ifw='/sbin/ifconfig wlan0'
#--------------------ps stuff
# custom recent ps
alias rps='ps -o user,pid,rss,stat,time,command -Aww |tail -n30'
# custom ps sorted by highest CPU usage
alias rcpu='ps -o %cpu,%mem,user,pid,rss,stat,time,command -Aww |sort -k1n'
alias pscpu='ps aux|sort -k3n'
#------------------------------------------------------------------------------

alias hlt='echo "Halting ...";sync;sudo halt'
alias sd='sudo /bin/bash'

[ $(id -u) -eq 0 ] && {
  # console debug: show all printk's on the console
  echo "8 4 1 4" > /proc/sys/kernel/printk
  # better core pattern
  # first set fs.suid_dumpable to 1 - debug mode
  # ref: https://www.kernel.org/doc/html/latest/admin-guide/sysctl/fs.html#suid-dumpable
  echo 1 > /proc/sys/fs/suid_dumpable
  echo "corefile:host=%h:gPID=%P:gTID=%I:ruid=%u:sig=%s:exe=%E" > /proc/sys/kernel/core_pattern
}
#echo -n "printk: " ; cat /proc/sys/kernel/printk

#----------------------- Git ! ----------------------------------------
alias gdiff='git diff -r'
alias gfiles='git diff --name-status -r'
alias gstat='git status ; echo ; git diff --stat -r'
alias giturl='git remote get-url --all origin'
alias gitlog='git log --graph --pretty=format:"%h: %ar: %s" --abbrev-commit'
 #git log --graph --pretty=oneline --abbrev-commit'
#----------------------------------------------------------------------
# auth
git config --global credential.helper 'cache --timeout 36000'  # in sec; thus, 10 hrs
#----------------------------------------------------------------------


###
# Some useful functions
###
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

# shortcut for git SCM;
# -to add a file(s) and then commit it with a commit msg
function gitac()
{
 [ $# -ne 2 ] && {
  echo "Usage: gitac filename \"commit-msg\""
  return
 }
 echo "git add $1 ..."
 git add $1
 echo "git commit -m ..."
 git commit -m "$2"
}

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

# end 0setup_rpi.bash
