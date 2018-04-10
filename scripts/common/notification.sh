#! /bin/bash
# send notifiction after build finish 
# send failed notifiction if build failed

# delete all implementations
# can use Jenkins mail mechanism 

tagn=""
astatus="successful"
projectn=""
branchn=""
while getopts :P:B:S:T: OPTION
do
    case "$OPTION" in
        P)
            projectn=${OPTARG}
        ;;
        B)
            branchn=${OPTARG}
        ;;
        S)
            astatus=${OPTARG}
        ;;
        T)
            tagn=${OPTARG}
        ;;
    esac
done


mailt=""
if [ "x${JENKINS_mail_to}" != "x" ]; then
    mailt=${JENKINS_mail_to}
fi


genmailto(){
    # add all submitors into mailt
    if [ -f ${build_report}/changeset.txt ]; then
        for aauth in `cat ${build_report}/changeset.txt | grep -v "^$" | awk '!/:$/{print $NF}'`; do
            cres=`echo ${mailt} | grep -E "^${aauth}|,${aauth},|${aauth}$"`
            if [ "x${cres}" == "x" ]; then
                mailt="${mailt},${aauth}"
            fi
        done
    fi
}


# initialize subject and content
subject="Ignore"
content=""


fsuccessful(){
if [ -f ${build_report}/changeset.txt ]; then
    subms=`cat ${build_report}/changeset.txt`
else
    subms="No build report"
fi
cat << FSEOF
Do not repply!
Build standard infomation:${BUILD_URL}
Project: ${projectn}
Branch: ${branchn}
BuildLevel: ${tagn}
Download: ${fileserverurl}/${projectn}/${branchn}/${tagn}

${subms}

FSEOF
}

ffailed(){
if [ -f ${build_report}/changeset.txt ]; then
    subms=`cat ${build_report}/changeset.txt`
else
    subms="No build report"
fi
tracelog=`cat ${build_report}/build_trace.log`
cat << FFEOF
Do not repply!
Build standard infomation: ${BUILD_URL}
Project: ${projectn}
Branch: ${branchn}
BuildLevel: ${tagn} 

TraceLog:
${tracelog}

${subms}

FFEOF
}

fcancelled(){
cat << FCEOF
Do not repply!
No submissions, cancelled this build

Project: ${projectn}
Branch: ${branchn}
BuildLevel: ${tagn} 
FCEOF
}
# 
#case ${astatus} in
#    successful)
#        subject="***Build Notification*** ${tagn} is ready"
#        content=`fsuccessful`
#    ;;
#    failed)
#        subject="***Failed Notification*** ${tagn} is failed"
#        content=`ffailed`
#    ;;
#    cancel)
#        subject="***Build Cancelled*** ${tagn} is ready"
#        content=`fcancelled`
#    ;;
#esac

#if [ "x${content}" == "x" ]; then
#    echo -e "Fatal error: during send build notification"
#    exit 9
#fi

#if [ "x${BUILD_URL}" != "x" ]; then
#    genmailto

#    ostype=`uname`
#    if [[ ${ostype} =~ "Linux" ]]; then

#        echo -e "${content}" | formail -I "From: jenkins@yuntongxun.com" -I "MIME-Version:1.0" -I "Content-type:text/html;charset=utf-8" -I "Subject: ${subject}" | sendmail -oi "${mailt}"

#    fi
#fi
