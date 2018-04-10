#! /bin/bash

# scm-source cotrol management
# actions as below:
#         check     ------ checking whether has commits after the last success build
#         pull      ------ sync local sandbox with remote repository
#         mktag     ------ create build-tag
#         post      ------ push the build-tag which created when running mktag


projectn=""
branchn="sandbox"
action=""
goldenbuild=false
#timestamp=`${script_home}/scripts/common/gendefts.sh`
timestamp=""
while getopts :P:B:A:Gt: OPTION
do
    case "$OPTION" in
        B)
            branchn=${OPTARG}
        ;;
        P)
            projectn=${OPTARG}
        ;;
        A)
            action=${OPTARG}
        ;;
        G)
            goldenbuild=true
        ;;
        t)
            timestamp=${OPTARG}
        ;;
    esac
done
eres=0

if [[ "x${projectn}" == "x" || "x${branchn}" == "x" ]]; then
    ${echomessage} 99
    ${echomessage} 1 wrong arguments, \"-P ${projectn}\" \"-B ${branchn}\"
    exit 9
fi


#echo -e "action=$action"
if [ "${action}" == "check" ]; then
    commitschkr=`${script_home}/scripts/scm/commitschk.sh -P ${projectn} -B ${branchn} -G ${goldenbuild}`
    if [ "${commitschkr}" == "nochange" ]; then
        ${echomessage} 2 No any submissions since the last successful build.....
        exit 5
    else
        ${echomessage} 2 checking new coming commits ...... DONE
    fi
elif [ "${action}" == "pull" ]; then
    ${script_home}/scripts/scm/gitpull.sh -P ${projectn} -B ${branchn}
    eres=$?
elif [ "${action}" == "mktag" ]; then
    ${script_home}/scripts/scm/mkbldtag.sh -P ${projectn} -B ${branchn} -T ${project_name}_${branch_name}_${timestamp}
    eres=$?
elif [ "${action}" == "post" ]; then
    ${script_home}/scripts/scm/commitbldtag.sh -P ${projectn} -B ${branchn}
    eres=$?
fi
exit ${eres}
