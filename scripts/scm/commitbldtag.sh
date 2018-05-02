#!/bin/bash
# push build tag to remote repository
# the tag created by mkbldtag.sh

projectn=""
branchn=""
while getopts :P:B: OPTION
do
    case "$OPTION" in
        B)
            branchn=${OPTARG}
        ;;
        P)
            projectn=${OPTARG}
        ;;
    esac
done

buildtag=$(${script_home}/scripts/common/getcontinuedbldtag.sh -P ${projectn} -B ${branchn} -L true)
if [ "${buildtag}" == "failed" ]; then
    ${echomessage} 1 failed to get continued build tag
    exit 9
fi
eres=0
osgidir=`pwd`
pushtagspro(){
    spro=${1}
    sprotag=${buildtag//${projectn}/${spro}}
    # assume that local git repository dir is defined on the 
    cd ${lsrcrepodir}/${spro}_build_${branchn}
    lltagn=`git tag -l | tail -n 1`
    if [ "${sprotag}" != "${lltagn}" ]; then
        ${echomessage} 1 failed to validating buildtags ...
        ${echomessage} 1 to run \"git tag -n1\", the lastest build tag on branch \"${branch_name}\" is \"${lltagn}\"
        ${echomessage} 1 the latest buildlevel is \"${buildtag}\"
    else
        git push origin ${lltagn}
        if [ $? -eq 0 ]; then
            ${echomessage} 2 successful: pushing tag \"${lltagn}\" to git repository ......
        else
            ${echomessage} 1 failed: to poshing  tag \"${lltagn}\"
            eres=9
        fi
    fi
}
if [[ "${JENKINS_createTag}" == "Yes" ]]; then
    # first get the latest commit UUID
    pushtagspro ${projectn}

fi
exit ${eres}
