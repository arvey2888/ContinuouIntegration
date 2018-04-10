#! /bin/bash

# post jobs
# step 1. git push tag
#       call scripts/scm.sh -P ${project_name} -B ${branch_name}

pron=${JOB_NAME}
intbn=${JENKINS_branchName}
timestamp=""
buildtag=""
ignorebldtag=false
while getopts :P:B:A:Gt:T:i OPTION
do
    case "$OPTION" in
        B)
            intbn=${OPTARG}
        ;;
        P)
            pron=${OPTARG}
        ;;
        t)
            timestamp=${OPTARG}
        ;;
        T)
            buildtag=${OPTARG}
        ;;
        i)
            ignorebldtag=true
        ;;
     esac
done


# neccessary variables checking
if [[ "x${pron}" == "x" || "x${intbn}" == "x" ]]; then
   echo -e "Both \"JOB_NAME=${pron}\" and \"branch_name=${intbn}\" must be defined..."
   exit 9
fi

cd $(dirname $0)
source ./const_settings.sh ${pron} ${intbn}


# get Buildtag from buildhome
if [ "x${buildtag}" == "x" ]; then
    buildtag=`${script_home}/scripts/common/getcontinuelbldtag.sh -P ${project_name} -B ${branch_name}`
    if [ "${buildtag}" == "failed" ]; then
        ${echomessage} 1 failed to get build message from buildhome......
        exit 9
    fi
else
    vres=`${script_home}/scripts/script_help/valbuildtag.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -i ${ignorebldtag}`
    if [ "${vres}" == "failed" ]; then
        ${echomessage} 1 failed to valid buildtag \"${buildtag}\" with \"${buildtrace}\" ......
        exit 9
    fi
fi

#=======================================================================================
${echomessage} 99 $0 $@
${echomessage} 2 BuildTag:\"${buildtag}\"
#=======================================================================================

${script_home}/scripts/scm.sh -P ${project_name} -B ${branch_name} -A post
if [ $? -eq 9 ]; then
    exit 9
fi
