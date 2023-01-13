#!/bin/bash

REPOS=( \
https://github.com/kaiwan/usefulsnips \
https://github.com/kaiwan/device-memory-readwrite \
https://github.com/kaiwan/seals \
https://github.com/kaiwan/L1_sysprg_trg \
https://github.com/kaiwan/L2_kernel_trg \
https://github.com/kaiwan/L3_dd_trg \
https://github.com/kaiwan/L5_debug_trg \
https://github.com/kaiwan/procmap \
https://github.com/kaiwan/vasu_grapher \
https://github.com/kaiwan/hacksec \
https://github.com/kaiwan/stanly \
https://github.com/kaiwan/Hands-on-System-Programming-with-Linux \
https://github.com/PacktPublishing/Learn-Linux-Kernel-Development \
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
   echo "git clone ${repo}"
   git clone ${repo}
   sleep 0.5
   echo
 done
 )
}

### 'main' here
clone_git_repos
sync
exit 0
