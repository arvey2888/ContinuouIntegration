#! /bin/bash
# calling ${build_home}/scripts/post-build.sh to finish post build tasks(such as signing process, or deliver more packages, war to rpm, combine some dirs, and so on)

projectn=""
branchn="sandbox"
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
if [ -f ./scripts/post_build.sh ]; then
    ${echomessage} 2 [${projectn}]:performing post tasks ...
    ./scripts/post_build.sh ${buildtag}
    eres=$?
    ${echomessage} 2 [${projectn}]:Done to perform post tasks
else
    ${echomessage} 2 [${projectn}]:no post tasks ...
fi
cd ${osgidir}
if [ ${eres} -ne 0 ]; then
    eres=9
fi
exit ${eres}
