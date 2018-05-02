#! /bin/bash

# build interface script
# step 1. copy source code from sandbox to buildhome
#        scripts/build.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -G ${goldenbuild} -A copysrc
# step 2. execute the previous jobs
#        scripts/build.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -G ${goldenbuild} -A pre-build
# step 3. execute the compiling and package jobs
#        scripts/build.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -G ${goldenbuild} -A fullbuild
# step 4. execute the post jobs
#        scripts/build.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -G ${goldenbuild} -A post-build

pron=${JOB_NAME}
intbn=""
goldenbuild=false
timestamp=""
buildtag=""
ignorebldtag=false
while getopts :P:B:A:Gt:T:i OPTION
do
    case "$OPTION" in
        B)
            intbn=${OPTARG}
        ;;
        P)
            pron=${OPTARG}
        ;;
        G)
            goldenbuild=true
        ;;
        t)
            timestamp=${OPTARG}
        ;;
        T)
            buildtag=${OPTARG}
        ;;
        i)
            ignorebldtag=true
        ;;
     esac
done


# neccessary variables checking
if [[ "x${pron}" == "x" || "x${intbn}" == "x" ]]; then
   echo -e "Both \"JOB_NAME=${pron}\" and \"branch_name=${intbn}\" must be defined..."
   exit 9
fi

cd $(dirname $0)
source ./const_settings.sh ${pron} ${intbn}


# get the local incompleted Buildtag
if [ "x${buildtag}" == "x" ]; then
    # pre-full.sh will create 
    buildtag=`${script_home}/scripts/common/getcontinuedbldtag.sh -P ${project_name} -B ${branch_name}`
    if [ "${buildtag}" == "failed" ]; then
        ${echomessage} 1 failed to get incompleted build ......
        exit 9
    fi
else
    # continue 
    vres=`${script_home}/scripts/script_help/valbuildtag.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -i ${ignorebldtag}`
    if [ "${vres}" == "failed" ]; then
        ${echomessage} 1 failed to valid buildtag \"${buildtag}\" with \"${buildtrace}\" ......
        exit 9
    fi
fi

#=======================================================================================
${echomessage} 99 $0 $@
${echomessage} 2 BuildTag:\"${buildtag}\"
#=======================================================================================
eres=0
# starting a build
# generate build tag
#if [ "x${ts}" != "x" ]; then
#    cts=`echo ${ts} | grep "^[[:digit:]]\{8\}-[[:digit:]]\{4\}$"`
#    if [ "${ts}" != "${cts}" ]; then
#        ${echomessage} 1 valid format of \"${ts}\" should be \"yyyymmdd-HHMM\"
#        exit 9
#    fi
#fi
#export buildtag=${project_name}_${branch_name}_$(${script_home}/scripts/common/gendefts.sh -t ${ts})

# step 1
${script_home}/scripts/build.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -G ${goldenbuild} -A copysrc
eres=$?
if [ ${eres} -eq 9 ]; then
    ${script_home}/scripts/common/fbuildtrace.sh -A copysrc -S FAILED
    ${script_home}/scripts/common/notification.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -S failed
    exit 9
else
    ${script_home}/scripts/common/fbuildtrace.sh -A copysrc -S PASSED
fi

# step 2
${script_home}/scripts/build.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -G ${goldenbuild} -A pre-build
if [ $? -eq 9 ]; then
    ${script_home}/scripts/common/fbuildtrace.sh -A prebuild -S FAILED
    ${script_home}/scripts/common/notification.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -S failed
    exit 9
else
    ${script_home}/scripts/common/fbuildtrace.sh -A prebuild -S PASSED
fi


# step 3
${script_home}/scripts/build.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -G ${goldenbuild} -A fullbuild
if [ $? -eq 9 ]; then
    ${script_home}/scripts/common/fbuildtrace.sh -A fullbuild -S FAILED
    ${script_home}/scripts/common/notification.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -S failed
    exit 9
else
    ${script_home}/scripts/common/fbuildtrace.sh -A fullbuild -S PASSED
fi
# step 4
${script_home}/scripts/build.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -G ${goldenbuild} -A post-build
if [ $? -eq 9 ]; then
    ${script_home}/scripts/common/fbuildtrace.sh -A postbuild -S FAILED
    ${script_home}/scripts/common/notification.sh -P ${project_name} -B ${branch_name} -T ${buildtag} -S failed
    exit 9
else
    ${script_home}/scripts/common/fbuildtrace.sh -A postbuild -S PASSED
fi
