#!/bin/bash
# For L2: Linux Kernel Internals
REPOS=( \
https://github.com/kaiwan/usefulsnips \
https://github.com/kaiwan/seals \
https://github.com/kaiwan/L2_kernel_trg \
https://github.com/kaiwan/procmap \
)

clone_git_repos()
{
 mkdir -p ${HOME}/kaiwanTECH 2>/dev/null
 cd ${HOME}/kaiwanTECH || exit 1

 (
 i=1
 IFS=$'\n'
 
 for repo in "${REPOS[@]}"
 do
   echo "git clone ${repo}"
   git clone ${repo}
   if [ $? -ne 0 ] ; then
	 dir=$(basename ${repo})
	 cd ${dir}
	 echo "git pull"
	 git pull
	 cd ..
   fi
   sleep 0.5
   echo
 done
 )
}

### 'main' here
clone_git_repos
sync
exit 0
