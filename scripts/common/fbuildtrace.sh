#! /bin/bash
# flush build trace

tagn=""
action=""
astatus=""
while getopts :A:S:T: OPTION
do
    case "$OPTION" in
        A)
            action=${OPTARG}
        ;;
        S)
            astatus=${OPTARG}
        ;;
        T)
            tagn=${OPTARG}
        ;;
    esac
done

# if init flag equar 1, re-create ${buildtrace} file
# execute once when build started, that means, only running "${script_home}/scripts/scm.sh .. -A pull"
case ${action} in
    clean)
        [ -f ${buildtrace} ] && rm -rf ${buildtrace}
        touch ${buildtrace}
    ;;
    mktag)
        echo -e "BuildTag:${tagn}" | tee -a ${buildtrace}
        echo -e "${tagn}" > ${build_report}/latestVersion.txt
    ;;
    check)
        echo -e "Checking whether has new commit ...... ${astatus} " | tee -a ${buildtrace}
    ;;
    pull)
        echo -e "Rebasing build branch ...... ${astatus} " | tee -a ${buildtrace}
    ;;
    copysrc)
        echo -e "Copying source code to ${build_home} ...... ${astatus} " | tee -a ${buildtrace}
    ;;
    prebuild)
        echo -e "Running pre-build.sh ...... ${astatus} " | tee -a ${buildtrace}
    ;;
    fullbuild)
        echo -e "Running fullbuild.sh ...... ${astatus} " | tee -a ${buildtrace}
    ;;
    postbuild)
        echo -e "Running post-build.sh ...... ${astatus} " | tee -a ${buildtrace}
    ;;
    upload)
        echo -e "Uploading ...... ${astatus} " | tee -a ${buildtrace}
    ;;
esac
