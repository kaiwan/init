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
https://github.com/kaiwan/drv_johannes \
https://github.com/kaiwan/sblkdev_blkmq \
https://github.com/kaiwan/L4_emblinux_trg \
https://github.com/kaiwan/L5_user_debug \
https://github.com/kaiwan/L5_kernel_debug \
https://github.com/kaiwan/procmap \
https://github.com/kaiwan/hacksec \
https://github.com/kaiwan/trccmd \
https://github.com/PacktPublishing/Linux-Kernel-Programming_2E \
https://github.com/PacktPublishing/Linux-Kernel-Programming-Part-2 \
https://github.com/PacktPublishing/Linux-Kernel-Debugging \
https://github.com/kaiwan/Hands-on-System-Programming-with-Linux \
https://github.com/kaiwan/flamegraph \

)

REPO_LOC=${HOME}/kaiwanTECH
#REPO_LOC=/flash_rootfs/home/debian/kaiwanTECH

clone_git_repos()
{
 mkdir -p ${REPO_LOC}/ 2>/dev/null
 cd ${REPO_LOC}/ || exit 1

 (
 i=1
 IFS=$'\n'
 
 for repo in "${REPOS[@]}"
 do
   echo "$i: git clone ${repo}"
   git clone ${repo} || {
     echo "exists; git pull (in $(pwd))"
     (cd ${REPO_LOC}/$(basename ${repo}) ; git pull || { \
       echo "*** ABORTED ***" ; true
      } )
   }
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
