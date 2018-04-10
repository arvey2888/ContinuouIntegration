#! /bin/bash
#assume that the file distribution file is a http server
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

osgidir=`pwd`
cd ${build_home}
if [ -d ${build_home}/upload ]; then
    # copy build logs and changset
    cp -rf logs upload
    cp -rf buildreports/changeset.txt upload
    for aitem in `ls ${build_home}/upload`; do
        ${script_home}/scripts/common/uploadf2s.sh -P ${projectn} -B ${branchn} -S ${build_home}/upload/${aitem} -T ${buildtag}
    done
    ${script_home}/scripts/common/uploadf2s.sh -uP ${projectn} -B ${branchn} -T ${buildtag} -S ${build_report}/latestVersion.txt
    ${script_home}/scripts/common/uploadf2s.sh -uP ${projectn} -B ${branchn} -T ${buildtag} -S ${build_report}/latestcommit.txt
fi
cd ${osgidir}
