#! /bin/bash
#assume that the file distribution file is a http server
projectn=""
branchn=""
buildtag=""
goldenbuild=false
while getopts :P:B:T:G: OPTION
do
    case "$OPTION" in
        B)
            branchn=${OPTARG}
        ;;
        P)
            projectn=${OPTARG}
        ;;
        T)
            buildtag=${OPTARG}
        ;;
        G)
            goldenbuild=${OPTARG}
        ;;
    esac
done
eres=0
osgidir=`pwd`
cd ${build_home}
if [ -f ./scripts/pre-build.sh ]; then
    ${echomessage} 2 [${projectn}]:performing pre tasks ...
    ./scripts/pre-build.sh -T ${buildtag}
    eres=$?
    if [ ${eres} -ne 0 ]; then
        ${echomessage} 2 [${projectn}]:Failed to perform pre tasks
        eres=9
    else
        ${echomessage} 2 [${projectn}]:Done to perform pre tasks
    fi
else
    ${echomessage} 2 [${projectn}]:no pre tasks
fi
cd ${osgidir}
exit ${eres}

