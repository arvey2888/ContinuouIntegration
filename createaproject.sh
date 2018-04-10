#! /bin/bash

# P project name
# J Job name
# B branch
# G git repo url
jenkinsu="admin"
jenkinsp="pass4you"


projectn=""
branchn="sandbox"
jobn=""
topproject=""

while getopts :P:B:J:T: OPTION
do
    case "$OPTION" in
        B)
            branchn=${OPTARG}
        ;;
        P)
            projectn=${OPTARG}
        ;;
        J)
            jobn=${OPTARG}
        ;;
        T)
            topproject=${OPTARG}
        ;;
     esac
done

if [ "x${JENKINS_job_name}" != "x" ]; then
    jobn="${JENKINS_job_name}"
fi

if [ "x${JENKINS_project_name}" != "x" ]; then
    projectn="${JENKINS_project_name}"
fi
if [ "x${JENKINS_branchName}" != "x" ]; then
    branchn="${JENKINS_branchName}"
fi
if [ "x${JENKINS_topproject}" != "x" ]; then
    topproject="${JENKINS_topproject}"
fi

if [ "x${JENKINS_gitlab_url}" == "x" ]; then
    giturl="git@gitlab.rongcloud.net"
else
    giturl="${JENKINS_gitlab_url}"
fi

export script_home=$(cd "$(dirname $BASH_SOURCE)"; pwd)
if [ "x${JENKINS_repositories_dir}" == "x" ]; then
    export lsrcrepodir=/data/repositories_dir
else
    export lsrcrepodir=${JENKINS_repositories_dir}
fi

if [[ "x${projectn}" == "x" || "x${branchn}" == "x" ]]; then
    echo -e "\e[1;31m\"Run format:source $0 Project_name branch[branch]_Name\"\e[0m"
fi
# checking template file
if [ -f ${script_home}/jenkins.export/${topproject}.config.xml ]; then
    [ ${script_home}/${topproject}.config.xml ] && rm -f ${script_home}/${topproject}.config.xml
    cp -f ${script_home}/jenkins.export/${topproject}.config.xml ${script_home}
    sed -i "s/VAR_BRANCH_NAME/"${branchn}"/" ${script_home}/${topproject}.config.xml

    token=`curl --user ${jenkinsu}:${jenkinsp} '${JENKINS_URL}crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)' 2> /dev/null`
    if [ "x${token}" == "x" ]; then
        curl -X POST --user ${jenkinsu}:${jenkinsp} -H "Content-Type: text/xml" --data-binary "@${script_home}/${topproject}.config.xml" ${JENKINS_URL}createItem?name=${jobn}
    else
        curl -X POST --user ${jenkinsu}:${jenkinsp} -H "Content-Type: text/xml" -H "Jenkins-Crumb:${token}" --data-binary "@${script_home}/${topproject}.config.xml" ${JENKINS_URL}createItem?name=${jobn}
    fi

    # create local repository

    cd ${lsrcrepodir}
    git clone -b ${branchn} ${giturl}:${topproject}/${projectn}.git ${jobn}_build_${branchn}
    cd -
    # update lsmapping.conf
    chk=`cat ${script_home}/lsmapping.conf | grep "${projectn}:${jobn}"`
    if [ "x${chk}" == "x" ]; then
        echo -e "${projectn}:${jobn}" >> ${script_home}/lsmapping.conf
    fi
fi
