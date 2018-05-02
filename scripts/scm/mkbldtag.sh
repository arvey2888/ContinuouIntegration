#!/bin/bash
# make a tag, not push to remote repository
# the tag will be pushed to remote after build succeeded.(commitbldtag.sh)

projectn=""
branchn=""
tagn=""
while getopts :P:B:T: OPTION
do
    case "$OPTION" in
        B)
            branchn=${OPTARG}
        ;;
        P)
            projectn=${OPTARG}
        ;;
        T)
            tagn=${OPTARG}
        ;;
    esac
done


# if tagn="" create a new tag following fixed principl
if [ "x${tagn}" == "x" ]; then
    ${echomessage} 99
    ${echomessage} 1 wrong arguments, \"-T ${tagn}\"
    exit 9
fi
eres=0
osgidir=`pwd`
mktagspro(){
    spro=${1}
    # assume that local git repository dir is defined on the 
    cd ${lsrcrepodir}/${spro}_build_${branchn}
    lastbldts=`${script_home}/scripts/common/getlatestbl.sh -P ${projectn} -B ${branchn} -F ${spro} -L true`
    lcommitts=`git log -n 1 --pretty=format:"%h" 2>${discarded}`
    if [ "${lastbldts}" != "${lcommitts}" ]; then
        git tag ${tagn//${projectn}/${spro}} -m "auto-created by build script baseon branch \"${branchn}\""
        if [ $? -eq 0 ]; then
            ${echomessage} 2 successful: auto-create tag \"${tagn}\" against on branch \"${branchn}\" git-project \"${projectn}\"
        else
            ${echomessage} 1 failed: auto-create tag \"${tagn}\" against on branch \"${branchn}\" git-project \"${projectn}\"
            eres=$((${eres}+1))
        fi
    fi
}
# first get the latest commit UUID

    mktagspro ${projectn}
cd ${osgidir}
if [ ${eres} -ne 0 ]; then
    eres=9
fi
exit ${eres}
