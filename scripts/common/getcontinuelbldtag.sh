#! /bin/bash
branchn="sandbox"
projectn=""
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
#getbtfromgit(){
#    ${echomessage} 2 \"${buildtrace}\" did not exist, get buildtag from git-repository
#    osgidir=`pwd`
#    cd ${lsrcrepodir}/${projectn}_build_${branchn}
#    buildtag=`git tag | head -n1 | grep "${projectn}_${branchn}_[[:digit:]]\{8\}-[[:digit:]]\{4\}"`
#    if [ "x${buildtag}" == "x" ]; then
#        #${echomessage} 1 failed to get buildtag ....
#        echo -e "failed"
#    else
#        echo -e "${buildtag}"
#    fi
#    cd ${osgidir}
#}
bt=""
if [ -f ${buildtrace} ]; then
    bt=`cat ${buildtrace} | awk -F ":" '/^BuildTag:'${projectn}'_'${branchn}'_20[12][0-9][01][0-9][0-3][0-9]-[0-9][0-9][0-9][0-9]/{print $2}'`
fi

if [ "x${bt}" != "x" ]; then
    echo -e "${bt}"
else
    echo -e "failed"
fi
