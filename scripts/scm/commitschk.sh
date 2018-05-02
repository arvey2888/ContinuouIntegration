#!/bin/bash
# checking whether has new committed since last successful build
projectn=""
branchn=""
goldenbuild=false
while getopts :P:B:G: OPTION
do
    case "$OPTION" in
        B)
            branchn=${OPTARG}
        ;;
        P)
            projectn=${OPTARG}
        ;;
        G)
            goldenbuild=${OPTARG}
        ;;
    esac
done


# auto-increase 
commitschk=0 

fetchsinglegpro(){
    spro=${1}
    if [ ! -d ${lsrcrepodir}/${spro}_build_${branchn} ]; then
        ${echomessage} 9 running git clone ${gitlabsshurl}/${spro}.git 
        cd ${lsrcrepodir}
        git clone -b ${branchn} ${gitlabsshurl}/${spro}.git ${spro}_build_${branchn}
    fi
    # assume that local git repository dir is defined on the 
    cd ${lsrcrepodir}/${spro}_build_${branchn}
    # first get the latest commit UUID
    git fetch &> ${discarded}
    if [ $? -ne 0 ]; then
        ${echomessage} 99
        ${echomessage} 1 fatal error occured, during run \"git pull\", in \"${lsrcrepodir}/${spro}_build_${branchn}\"
        exit 9
    fi
    lastcommit=`${script_home}/scripts/common/getlatestbl.sh -P ${projectn} -B ${branchn} -F ${spro} -L true`
    echo -e "DEBUG: $spro $lastcommit"

    if [ "${lastcommit}" == "999999" ]; then
        commitschk=$((${commitschk}+1))
    elif [ "x${lastcommit}" != "x" ]; then
        echo -e "DEBUG: elif"
        mcommits=`git log ${lastcommit}..HEAD --pretty=format:"%h" | wc -l`
        if [ ${mcommits} -le 0 ]; then
            commitschk=$((${commitschk}+1))
        fi
    fi
}

if [ "${goldenbuild}" == "true" ]; then
    echo -e "commits"
else
    # assume that local git repository dir is defined on the 
    fetchsinglegpro ${projectn}

    if [ ${commitschk} -eq 0 ]; then
        echo -e "nochange"
    else
        echo -e "commits"
    fi
fi
exit 0
