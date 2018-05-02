#! /bin/bash
# calling ${build_home}/scripts/build.sh to finish compiling and packaging tasks
# ${script_home}/scripts/build.sh:
#     1. change working dir
#     2. running mvn, gradlew, or xcodebuild 
#     3. create ${build_home}/upload
#     4. copying the binary package into upload dir
# ${build_home}/upload will be uploaded to file-server, and renamed as build-tag(uploadbuild.sh)

projectn=""
branchn="sandbox"
buildtag=""
goldenbuild=false
while getopts :P:B:T:G: OPTION
do
    case "$OPTION" in
        P)
            projectn=${OPTARG}
        ;;
        B)
            branchn=${OPTARG}
        ;;
        T)
            buildtag=${OPTARG}
        ;;
        G)
            goldenbuild=${OPTARG}
        ;;
    esac
done
if [ "x${buildtag}" == "x" ]; then
    ${echomessage} 1 [${projectn}]:must use \"-T buildtag\" to run \"build.sh\"
    exit 9
fi
eres=0
osgidir=`pwd`
cd ${build_home}
if [ -f ./scripts/build.sh ]; then
    ./scripts/build.sh -T ${buildtag} -G ${goldenbuild}
    eres=$?
    if [ ${eres} -ne 0 ]; then
        eres=9
    fi
else
   ${echomessage} 1 [${projectn}]:The interface script \"build.sh\" does not exist
   exit 9
fi
cd ${osgidir}
exit ${eres}
