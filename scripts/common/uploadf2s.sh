#! /bin/bash
# upload a file or a folder to file-server
# fixed dir-tree "${fileserver}:${dailybuilds}/${projectn}/${branchn}"


projectn=""
branchn="sandbox"
buildlevel=""
sourcef=""
updatelv=false
while getopts :P:B:T:S:u OPTION
do
    case "$OPTION" in
        B)
            branchn=${OPTARG}
        ;;
        P)
            projectn=${OPTARG}
        ;;
        T)
            buildlevel=${OPTARG}
        ;;
        S)
            sourcef=${OPTARG}
        ;;
        u)
            updatelv=true
        ;;
    esac
done

if [ "x${sourcef}" != "x" ]; then
   if [ ${updatelv} == "true" ]; then
#       [ ! -d ${JENKINS_fileserver}/${projectn}/${branchn} ] && mkdir -p ${JENKINS_fileserver}/${projectn}/${branchn}
#       cp -rf ${sourcef} ${JENKINS_fileserver}/${projectn}/${branchn}
       ssh -i ${sshkey} ${fsuser}@${fileserver} "[ ! -d ${dailybuilds}/${projectn}/${branchn} ] && mkdir -p ${dailybuilds}/${projectn}/${branchn}"
       scp -r -i ${sshkey} ${sourcef} ${fsuser}@${fileserver}:${dailybuilds}/${projectn}/${branchn} 
   else
       ssh -i ${sshkey} ${fsuser}@${fileserver} "[ ! -d ${dailybuilds}/${projectn}/${branchn}/${buildlevel} ] && mkdir -p ${dailybuilds}/${projectn}/${branchn}/${buildlevel}"
       scp -r -i ${sshkey} ${sourcef} ${fsuser}@${fileserver}:${dailybuilds}/${projectn}/${branchn}/${buildlevel}
#       [ ! -d ${JENKINS_fileserver}/${projectn}/${branchn}/${buildlevel} ] && mkdir -p ${JENKINS_fileserver}/${projectn}/${branchn}/${buildlevel}
#       cp -rf ${sourcef} ${JENKINS_fileserver}/${projectn}/${branchn}/${buildlevel}
   fi
fi

