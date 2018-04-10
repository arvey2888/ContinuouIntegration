#! /bin/bash
timestamp=""
while getopts :t: OPTION
do
    case "$OPTION" in
        t)
            timestamp=${OPTARG}
        ;;
    esac
done
if [ "x${timestamp}" != "x" ]; then
    cts=`echo ${timestamp} | grep "^[[:digit:]]\{8\}-[[:digit:]]\{4\}$"`
    if [ "${timestamp}" == "${cts}" ]; then
        echo ${timestamp}
    else
        date "+%Y%m%d-%H%M"
    fi
else
    date "+%Y%m%d-%H%M"
fi

