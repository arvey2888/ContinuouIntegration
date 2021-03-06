#! /bin/bash
# validate build tag, used to continue build process base on ${build_home}
# build infomation saved in ${build_home}/buildreport


project_name=""
branch_name=""
buildtag=""
ignorebldtag=false
while getopts :P:B:T:i OPTION
do
    case "$OPTION" in
        B)
            branch_name=${OPTARG}
        ;;
        P)
            project_name=${OPTARG}
        ;;
        T)
            buildtag=${OPTARG}
        ;;
        i)
            ignorebldtag=${OPTARG}
        ;;
     esac
done


# neccessary variables checking
if [[ "x${project_name}" == "x" || "x${branch_name}" == "x" ]]; then
   echo -e "Both \"JOB_NAME=${pron}\" and \"branch_name=${intbn}\" must be defined..."
   exit 9
fi

# get the local incompleted Buildtag
lbldtag=`${script_home}/scripts/common/getcontinuedbldtag.sh -P ${project_name} -B ${branch_name}`
if [ "${ignorebldtag}" == "false" ]; then
    if [ "x${buildtag}" != "x" ]; then
        if [ "${buildtag}" != "${lbldtag}" ]; then
            echo -e "failed"
            exit 9
        fi
    elif [ "x${lbldtag}" != "x" ]; then
        buildtag=${lbldtag}
    else
        echo -e "failed"
        exit 9
    fi
else
    if [ "x${buildtag}" == "x" ]; then
        if [ "x${lbldtag}" != "x" ]; then
            buildtag=${lbldtag}
        else
            buildtag=${project_name}_${branch_name}_$(${script_home}/scripts/common/gendefts.sh)
        fi
    fi
fi

# checking buildtag format, invalid format is not allowed
cbtg=`echo ${buildtag} | grep "${project_name}_${branch_name}_[0-9]\{8\}-[0-9]\{4\}"`
if [ "${buildtag}" != "${cbtg}" ]; then
    echo -e "failed"
    exit 9
fi

echo -e "${buildtag}"
exit 0
