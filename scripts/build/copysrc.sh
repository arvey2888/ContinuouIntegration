#! /bin/bash
# copy source code from ${lsrcrepodir} to ${build_home}
# why copy code process? this can make sure that git pull was not broken by unexpected issue(such as temporary changes), 

projectn=""
branchn="sandbox"
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
# delete the current project's sources
${echomessage} 2 clean \"${build_home}\" ......
for aitem in `find ${build_home} -mindepth 1 -maxdepth 1`; do
    if [ "${aitem}" != "${build_report}" ]; then
        ${echomessage} 3 removing \"${aitem}\" ......
        rm -rf ${aitem}
    fi
done
echo -e "copying source code, from ${lsrcrepodir}/${projectn}_build_${branchn}/* to ${build_home}"
cp -rf ${lsrcrepodir}/${projectn}_build_${branchn}/* ${build_home}
exit 0
