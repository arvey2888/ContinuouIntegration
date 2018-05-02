#! /bin/bash
# build information saved in ${build_home}/buildreport/build_trace.log
# ${script_home}/scripts/common/fbuildtrace.sh will append a line to build_trace.log

# build_trace.log sample
# Checking whether has new commit ...... DONE
# Rebasing build branch ...... DONE
# BuildTag:com.xxxx_20180419-1522
# Copying source code to /data/ci/buildhome/com.xxxx_master ...... PASSED
# Running pre-build.sh ...... PASSED
# Running fullbuild.sh ...... PASSED
# Running post-build.sh ...... PASSED


# get the tag of the incomplete build

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

bt=""
if [ -f ${buildtrace} ]; then
    bt=`cat ${buildtrace} | awk -F ":" '/^BuildTag:'${projectn}'_'${branchn}'_20[12][0-9][01][0-9][0-3][0-9]-[0-9][0-9][0-9][0-9]/{print $2}'`
fi

if [ "x${bt}" != "x" ]; then
    echo -e "${bt}"
else
    echo -e "failed"
fi
