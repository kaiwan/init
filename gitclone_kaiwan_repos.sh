#!/bin/bash
set -euo pipefail

REPOS=( \
https://github.com/kaiwan/usefulsnips \
https://github.com/kaiwan/device-memory-readwrite \
https://github.com/kaiwan/seals \
https://github.com/kaiwan/L0_cli_trg \
https://github.com/kaiwan/L1_sysprg_trg \
https://github.com/kaiwan/L2_kernel_trg \
https://github.com/kaiwan/L3_dd_trg \
https://github.com/kaiwan/labrat_drv \
https://github.com/kaiwan/L4_emblinux_trg \
https://github.com/kaiwan/L5_debug_trg \
https://github.com/kaiwan/procmap \
https://github.com/kaiwan/hacksec \
https://github.com/kaiwan/trccmd \
https://github.com/PacktPublishing/Linux-Kernel-Programming \
https://github.com/PacktPublishing/Linux-Kernel-Programming_2E \
https://github.com/PacktPublishing/Linux-Kernel-Programming-Part-2 \
https://github.com/PacktPublishing/Linux-Kernel-Debugging \
https://github.com/kaiwan/Hands-on-System-Programming-with-Linux \
)

clone_git_repos()
{
 mkdir -p ${HOME}/kaiwanTECH 2>/dev/null
 cd ~/kaiwanTECH || exit 1

 (
 i=1
 IFS=$'\n'
 
 for repo in "${REPOS[@]}"
 do
   echo "$i: git clone ${repo}"
   git clone ${repo}
   sleep 0.5
   let i=i+1
   echo
 done
 )
}

### 'main' here
clone_git_repos
sync
exit 0
