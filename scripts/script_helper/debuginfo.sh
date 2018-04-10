#! /bin/bash
# sub-script, called by top(entry) script
# run on both controller and end-node 
debugl=$1
shift

if [ "$debug" == "" ]; then
    ldebug=5
else
    ldebug=$debug
fi

if [ $debugl -eq 0 ]; then
    echo -e "\e[1;31m FATAL ERROR!!!\e[0m"
elif [ $debugl -eq 66 ]; then
    #remoteip=$1
    msgfile=$1
    if [ "${savelog}" = "yes" ]; then
        echo -e "\e[1;31m=================BEGIN ERROR MESSAGE==================\e[0m" 2>&1 | tee -a ${stderrlog}
        echo -e "     Error File: \e[1;31m\"${msgfile}\"\e[0m" 2>&1 | tee -a ${stderrlog}
        cat ${msgfile} >> ${stderrlog}
        #echo -e "     Remote Address \e[1;31m\"${remoteip}\"\e[0m" 2>&1 | tee -a ${stderrlog}
        #cat ${stderrlog%/*}/${remoteip}_${stderrlog##*/} | tee -a ${stderrlog}
        echo -e "\e[1;31m==================END ERROR MESSAGE===================\e[0m" 2>&1|tee -a ${stderrlog}
    else
        echo -e "\e[1;31m=================BEGIN ERROR MESSAGE==================\e[0m"
        echo -e "     Error File: \e[1;31m\"${msgfile}\"\e[0m"
        cat ${msgfile}
        echo -e "\e[1;31m==================END ERROR MESSAGE===================\e[0m"
    fi
elif [ $debugl -eq 99 ]; then
    if [ "${savelog}" = "yes" ]; then
        echo -e "\n====================================================" 2>&1| tee -a ${stderrlog}
        echo -e "$(date "+%Y%m%d-%H%M") CallStack: $@ " 2>&1 | tee -a ${stderrlog}
    else
        echo -e "\n====================================================" 2>&1| tee -a ${stderrlog}
        echo -e "$(date "+%Y%m%d-%H%M") CallStack: $@ " 2>&1 | tee -a ${stderrlog}
    fi
elif [ $debugl -eq 88 ]; then
    if [ "${savelog}" = "yes" ]; then
        echo -e "\n====================================================" 2>&1| tee -a ${stdoutlog}
        echo -e "$(date "+%Y%m%d-%H%M") running: $@ " 2>&1 | tee -a ${stdoutlog}
        echo -e "====================================================\n" 2>&1| tee -a ${stdoutlog}
    else
        echo -e "\n===================================================="
        echo -e "$(date "+%Y%m%d-%H%M") running: $@ "
        echo -e "====================================================\n"
    fi
elif [ $debugl -eq 77 ]; then
    if [ "${savelog}" = "yes" ]; then
        echo -e "\n          ********** EMPHASIZE **********" 2>&1| tee -a ${stdoutlog}
        echo -e "$(date "+%Y%m%d-%H%M"): $@ " 2>&1 | tee -a ${stdoutlog}
        echo -e "          ********** END **********\n" 2>&1| tee -a ${stdoutlog}
    else
        echo -e "\n          ********** EMPHASIZE **********"
        echo -e "$(date "+%Y%m%d-%H%M"): $@ "
        echo -e "          ********** END **********\n"
    fi
elif [ $debugl -eq 55 ]; then
    if [ "${savelog}" = "yes" ]; then
        echo -e "    $@" 2>&1|tee -a ${validatinglog}
    else
        echo -e "    $@"
    fi
elif [ $debugl -eq 1 ]; then
    if [ "${savelog}" = "yes" ]; then
        echo -e "\e[1;31m    ERROR MESSAGE:\e[0m $@" 2>&1 | tee -a ${stderrlog}
        echo -e "    ERROR MESSAGE: $@" 2>&1 | tee -a ${stderrlog}
    else
        echo -e "\e[1;31m    ERROR MESSAGE:\e[0m $@" 
        echo -e "    ERROR MESSAGE: $@"
    fi
elif [ $debugl -le $ldebug ]; then
    if [ "${savelog}" = "yes" ]; then
        echo -e "Message: $@" 2>&1 | tee -a ${stdoutlog}
    else
        echo -e "Message: $@"
    fi
fi

