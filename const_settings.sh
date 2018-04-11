#/bin/bash
export jenkinsws=`pwd`
export script_home=$(cd "$(dirname $BASH_SOURCE)"; pwd)
[ "x${debug}" == "x" ] && export debug=2

if [ "x${JOB_NAME}" != "x" ]; then
#run in jenkins 
	export project_name=`${script_home}/proshortn.sh -P ${JOB_NAME}`
elif [ "x${1}" != "x" ]; then
#run in shell and figure out the branch name
	export project_name=`${script_home}/proshortn.sh -P ${1}`
fi

if [[ "x${JOB_NAME}" != "x" && "x${JENKINS_branchName}" != "x" ]]; then 
#run in jenkins
	export branch_name=${JENKINS_branchName}
elif [ "x${2}" != "x" ]; then 
#run in shell and figure out the branch name
	export branch_name=${2}
else
	export branch_name=sandbox
fi




if [[ "x${project_name}" == "x" ]]; then
    echo -e "\e[1;31m\"Run format:source $0 Project_name branch[branch]_Name\"\e[0m"
fi

if [ "x${JENKINS_reposandbox}" == "x" ]; then
    # default settings
    export lsrcrepodir=/app/ci/src_sandbox/svn_sandbox
else
    export lsrcrepodir=${JENKINS_reposandbox}
fi



if [ ! -d ${lsrcrepodir}/${project_name}_build_${branch_name} ]; then
    echo -e "\e[1;31m\"There is no source code folder for ${branch_name} of ${project_name} in ${lsrcrepodir}\e[0m"
fi
if [ "x${JENKINS_fileserver}" == "x" ]; then
    # default settings
    export fileserver=127.0.0.1
else
    export fileserver=${JENKINS_fileserver}
fi
if [ "x${JENKINS_fileserverurl}" == "x" ]; then
    # default settings
    export fileserverurl=http://127.0.0.1
else
    export fileserverurl=${JENKINS_fileserverurl}
fi
if [[ "x${JENKINS_sshkey}" != "x" && -f ${JENKINS_sshkey} ]]; then
    export sshkey=${JENKINS_sshkey}
else
    # default settings
    export sshkey=${HOME}/.ssh/id_rsa
fi
export echomessage=${script_home}/scripts/script_helper/debuginfo.sh
export curlcmd=/usr/bin/curl
if [ "x${JENKINS_buildhome}" == "x" ]; then
    # default settings
    export build_home=${jenkinsws}/${project_name}_${branch_name}
else
    export build_home=${JENKINS_buildhome}/${project_name}_${branch_name}
fi

if [ "x${JENKINS_fsuser}" == "x" ]; then
    export fsuser=jenkins
else
    export fsuser=JENKINS_fsuser
if

if [ "x${JENKINS_dailybuilds}" == "x" ]; then
    # default settings
    export dailybuilds=/dailybuilds
else
    export dailybuilds=${JENKINS_dailybuilds}
fi
if [[ "x${JENKINS_gitlabserver}" != "x" && "x${JENKINS_gitlabgroup}" != "x" ]]; then
    export gitlabsshurl="${JENKINS_gitlabserver}:${JENKINS_gitlabgroup}"
else
    # default settings
    export gitlabsshurl="git@gitlab.mycomp.com:server-java"
fi
export gitlabapiurl="http://gitlab.mycomp.com/api/v4"


export build_report=${build_home}/buildreports
[ ! -d ${build_report} ] && mkdir -p ${build_report}
export discarded=/dev/null
export gitremotes=remotes/origin

#======================================================================================================

ostype=`uname`
if [[ ${ostype} =~ "Darwin" ]]; then
    export LANG=en_US.UTF-8
    export PATH=${PATH}:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
else
    export PATH=${PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
    if [ "x${JENKINS_JAVA_HOME}" != "x" ]; then
        export JAVA_HOME=${JENKINS_JAVA_HOME}
        export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:/usr/local/jdk/lib/tools.jar
        export PATH=${JENKINS_JAVA_HOME}/bin:${PATH}
    fi
    if [ "x${JENKINS_MAVEN_HOME}" != "x" ]; then
        export MAVEN_HOME=${JENKINS_MAVEN_HOME}
    fi
    if [ "x${MAVEN_HOME}" != "x" ]; then
        export PATH=${MAVEN_HOME}/bin:${PATH}
    fi
fi

#======================================================================================================
timestamp=$(date "+%Y%m%d-%H%M")
export savelog="yes"
export stdoutlog=${script_home}/logs/run_${timestamp}.log
export stderrlog=${script_home}/logs/error_${timestamp}.log
[ ! -d ${script_home}/logs ] && mkdir ${script_home}/logs
touch ${stdoutlog}
touch ${stderrlog}

#======================================================================================================
# trace mechanism, save current build process steps
# this file is very important, build meta information in it
# such build tag
# why save these meta information? message exchange
# one build is splited many steps, such as, pre-task, full building, post-task, uploading, notification ....
# 
export buildtrace=${build_report}/build_trace.log


#======================================================================================================

