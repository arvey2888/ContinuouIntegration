#! /bin/bash

# jobs:
#    copysrc              ------ copy all source code from ${lsrcrepodir} to ${build_home}
#    execute pre-build    ------ call-back pre-build.sh to finish the project's customized tasks
#    execute build process------ call-back build.sh
#    execute post-build   ------ call-back post-build.sh
#    upload build result  ------ upload build result to file distribution server


# one action argrument -A

projectn=""
branchn=""
action=""
goldenbuild=false
buildtag=""
while getopts :P:B:A:G:T: OPTION
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
        T)
            buildtag=${OPTARG}
        ;;
    esac
done

eres=0
${echomessage} 2 $0 $@
if [ "${action}" == "copysrc" ]; then
    ${script_home}/scripts/build/copysrc.sh -P ${projectn} -B ${branchn} -T ${buildtag}
    eres=$?
fi
if [ "${action}" == "pre-build" ]; then
    ${script_home}/scripts/build/pre-build.sh -P ${projectn} -B ${branchn} -G ${goldenbuild} -T ${buildtag}
    eres=$?
fi

if [ "${action}" == "fullbuild" ]; then
    ${script_home}/scripts/build/build.sh -P ${projectn} -B ${branchn} -G ${goldenbuild} -T ${buildtag}
    eres=$?
fi
if [ "${action}" == "post-build" ]; then
    ${script_home}/scripts/build/post-build.sh -P ${projectn} -B ${branchn} -G ${goldenbuild} -T ${buildtag}
    eres=$?
fi
if [ "${action}" == "upload" ]; then
    ${script_home}/scripts/build/uploadbuild.sh -P ${projectn} -B ${branchn} -G ${goldenbuild} -T ${buildtag}
    eres=$?
fi
exit ${eres}
