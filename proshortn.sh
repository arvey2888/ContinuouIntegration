#! /bin/bash
# pmap=("long_project_name:short_project_name" )
# E.g. pmap=("RCE-server:RCE")
pmap=""
for als in `cat ${script_home}/lsmapping.conf | sort | uniq`; do
    if [ "x${pmap}" == "x" ]; then
        pmap="${als}"
    else
        pmap="${pmap} ${als}"
    fi
done
#pmap=("RCE-Server:RCE")
projectn=""
while getopts :P: OPTION
do
    case "$OPTION" in
        P)
            projectn=${OPTARG}
        ;;
    esac
done

if [ "x${projectn}" != "x" ]; then
    psn=${projectn}
    for ai in `echo ${pmap[@]}`; do
        ln=${ai%:*}
        if [ "${ln}" == "${projectn}" ]; then
            psn=${ai##*:}
            break
        fi
    done
    echo -e "${psn}"
else
    echo -e "ERROR"
fi
