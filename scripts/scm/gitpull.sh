#!/bin/bash
# auto merge integrate branch to build branch
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

pullsinglegpro(){
    spro=${1}
    if [ ! -d ${lsrcrepodir}/${spro}_build_${branchn} ]; then
        ${echomessage} 9 running git clone ${gitlabsshurl}/${spro}.git 
        cd ${lsrcrepodir}
        git clone -b ${branchn} ${gitlabsshurl}/${spro}.git ${spro}_build_${branchn}
    fi
    # assume that local git repository dir is defined on the 
    cd ${lsrcrepodir}/${spro}_build_${branchn}
    lcommitbefm=`git log -n 1 --pretty=format:"%h" 2>${discarded}`
    # first get the latest commit UUID
    # disable build_branch machenism
    #git merge ${gitremotes}/${branchn} &> ${discarded}
    git pull > ${discarded} 2>&1
    gitpull=`git pull | grep "^Already up-to-date.$"`
    if [ "x${gitpull}" == "x" ]; then
        ${echomessage} 99
        ${echomessage} 1 fatal error during to run \"git merge\", fix the error first, run again ......
        exit 9
    fi
    #by datetime
    # timestamp increace 1 second to skip the last commit
    #lastbldts=`${script_home}/scripts/common/getlatestbl.sh -P ${projectn} -F ${spro} -B ${branchn} -L true`
    #if [ "x${lastbldts}" == "x" ]; then
    #    lastbldts=${lcommitbefm}
    #    #    lastbldts=`git log -n 1 --pretty=format:"%at" 2>${discarded}`
    #fi
    #lastbldts=$((${lastbldts}+1))
    #sts=`date -d "1970-01-01 UTC ${lastbldts} seconds" "+%Y-%m-%d %H:%M:%S"`
    #mcommits=`git log  --pretty=format:"%h %s %ae" | grep -v "Merge[[:space:]]branch"`
 
    #by commit id
  
    lastbldts=`${script_home}/scripts/common/getlatestbl.sh -P ${projectn} -B ${branchn} -F ${spro} -L true`
    #echo -e "DEBUG: ${lastbldts}"
    if [ "${lastbldts}" == "999999" ]; then
        # the laest 5
        #echo -e "git log -n 5 --pretty=format:\"%h %s %ae\""
        mcommits=`git log -n 5 --pretty=format:"%h %s %ae" | grep -v "Merge[[:space:]]branch"`
    else
        #echo -e "git log ${lastbldts}..HEAD --pretty=format:\"%h %s %ae\""
        mcommits=`git log ${lastbldts}..HEAD --pretty=format:"%h %s %ae" | grep -v "Merge[[:space:]]branch"`
    fi

    # save the latest commit id for next build
    lcommitts=`git log -n 1 --pretty=format:"%h" 2>${discarded}`

    #touch ${build_report}/latestcommit.txt
    echo -e "${spro} ${lcommitts}" >> ${build_report}/latestcommit.txt
    echo -e "\n${spro}:" |tee -a ${build_report}/changeset.txt
    echo -e "${mcommits}" |tee -a ${build_report}/changeset.txt
    # create tag
}





# checking in parent scripts ../scm.sh
#if [[ "x${projectn}" == "x" || "x${branchn}" == "x" ]]; then
#    #${echomessage} 99
#    ${echomessage} 1 wrong arguments, \"-P ${projectn}\" \"-B ${branchn}\"
#    exit 9
#fi

eres=0
osgidir=`pwd`

# create changeset files, save it in build working dir
if [ -f ${build_report}/changeset.txt ]; then
    rm -f ${build_report}/changeset.txt
fi
echo -e "submissions list:" | tee ${build_report}/changeset.txt
if [ -f ${build_report}/latestcommit.txt ]; then
    rm -f ${build_report}/latestcommit.txt
fi
# assume that local git repository dir is defined on the 
# pullsinglegpro ${projectn}

    # iOS code, default only one project
    pullsinglegpro ${projectn}

cd ${osgidir}

exit ${eres}
