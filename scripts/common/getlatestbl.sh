#! /bin/bash
#get latest buildlevel
#assume that the file distribution file is a http server
projectn=""
branchn=""
lt=false
filtero=""
while getopts :P:B:L:F: OPTION
do
    case "$OPTION" in
        B)
            branchn=${OPTARG}
        ;;
        P)
            projectn=${OPTARG}
        ;;
        L)
            lt=${OPTARG}
        ;;
        F)
            filtero=${OPTARG}
        ;;
    esac
	
done
#if [[ "x${projectn}" == "x" || "x${branchn}" == "x" ]]; then
#    #${echomessage} 99
#    ${echomessage} 1 wrong arguments, \"-p=${projectn}\" \"-n=${branchn}\"
#    exit 9
#else
if [ "${lt}" = "true" ]; then
    # echo -e "DEBUG:${curlcmd} ${fileserverurl}/${projectn}/${branchn}/latestcommit.txt $filtero"
    vr=`${curlcmd} ${fileserverurl}/${projectn}/${branchn}/latestcommit.txt 2>${discarded} | grep "^${filtero}"`
    if [ $? != 0 ]; then
        echo -e "999999"
    elif [ "x${vr}" == "x" ]; then
        echo -e "999999"
    else
        committid=`echo ${vr} | awk '{print $2}'`
        echo -e "${committid}"
    fi
else
    lv=$(${curlcmd} ${fileserverurl}/${projectn}/${branchn}/latestVersion.txt 2>${discarded})
    vr=$(echo ${lv}| grep "_[[:digit:]]\{8\}-[[:digit:]]\{4\}")
    if [ $? != 0 ]; then
        echo -e "999999"
    elif [ "x${vr}" != "x" ]; then
        echo -e "999999"
    else
        latestbl=`echo ${vr} | awk '{print $2}'`
        echo -e "${latestbl}"
    fi
fi

