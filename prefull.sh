#! /bin/bash

# SCM Jobs.
# step 1.  commits checking
#      call scripts/scm.sh -P ${project_name} -B ${branch_name} -A check
# step 2.  git pull
#      call scripts/scm.sh -P ${project_name} -B ${branch_name} -A pull
# step 3. make a tag named as build-level
#      call scripts/scm.sh -P ${project_name} -B ${branch_name} -A mktag

pron=${JOB_NAME}
intbn=
ts=""
while getopts :P:B:t: OPTION
do
    case "$OPTION" in
        B)
            intbn=${OPTARG}
        ;;
        P)
            pron=${OPTARG}
        ;;
        t)
            ts=${OPTARG}
        ;;
     esac
done

# neccessary variables checking
if [[ "x${pron}" == "x" || "x${intbn}" == "x" ]]; then
   echo -e "Both \"JOB_NAME\" and \"JENKINS_branchName\" must be defined..."
   exit 9
fi

cd $(dirname $0)
source ./const_settings.sh ${pron} ${intbn}

if [ "x${ts}" == "x" ]; then
    ts=`${script_home}/scripts/common/gendefts.sh`
fi

eres=0
# starting a build
# generate build tag
if [ "x${ts}" != "x" ]; then
    cts=`echo ${ts} | grep "^[[:digit:]]\{8\}-[[:digit:]]\{4\}$"`
    if [ "${ts}" != "${cts}" ]; then
        ${echomessage} 1 valid format of \"${ts}\" should be \"yyyymmdd-HHMM\"
        exit 9
    fi
fi
timestamp=`${script_home}/scripts/common/gendefts.sh -t ${ts}`
buildtag=${project_name}_${branch_name}_${timestamp}

# create buildtrace file
# after this, each sub-job will append a line in buildtrace, cat get build status through the file
${script_home}/scripts/common/fbuildtrace.sh -A clean


#=======================================================================================
${echomessage} 99 $0 $@
${echomessage} 2 TimeStamp:\"${timestamp}\"
#=======================================================================================
# step 1
if [ "${JENKINS_goldenbuild}" == "true" ]; then
    ${script_home}/scripts/scm.sh -GP ${project_name} -B ${branch_name} -A check
else
    ${script_home}/scripts/scm.sh -P ${project_name} -B ${branch_name} -A check
fi
eres=$?
echo -e "checking ${eres}"
if [ ${eres} -eq 9 ]; then
    ${script_home}/scripts/common/fbuildtrace.sh -A check -S FAILED
    ${script_home}/scripts/common/notification.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -S failed
    exit ${eres}
elif [ ${eres} -eq 5 ]; then
    ${script_home}/scripts/common/fbuildtrace.sh -A check -S NOCHANGE
    ${script_home}/scripts/common/notification.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -S cancel
#    echo -e "No submissions since the last sucessful build ......"
    echo -e "Canncel this buld ......"
    exit 9
else
    ${script_home}/scripts/common/fbuildtrace.sh -A check -S DONE
fi

# step 2 disable pull function on svn
${script_home}/scripts/scm.sh -P ${project_name} -B ${branch_name} -A pull
eres=$?
if [ ${eres} -eq 9 ]; then
    ${script_home}/scripts/common/fbuildtrace.sh -A pull -S FAILED
    ${script_home}/scripts/common/notification.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -S failed
    exit ${eres}
else
    ${script_home}/scripts/common/fbuildtrace.sh -A pull -S DONE
fi


# step 3
${script_home}/scripts/scm.sh -P ${project_name} -B ${branch_name} -A mktag -t ${timestamp}
eres=$?
if [ ${eres} -eq 9 ]; then
    ${script_home}/scripts/common/fbuildtrace.sh -T ${project_name}_${branch_name}_${timestamp} -A mktag -S FAILED
    ${script_home}/scripts/common/notification.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -S failed
    exit ${eres}
else
    ${script_home}/scripts/common/fbuildtrace.sh -T ${project_name}_${branch_name}_${timestamp} -A mktag -S DONE
fi
exit 0
