#!/bin/bash
## (C) George Goulas, 2011
##
## Proxy service configuration script for OSX
## tested on MacOSX Lion 10.6
##

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 
source ${ROOT_DIR}/config.sh
 
SSH_CMD="ssh ${SSH_OPTS} ${PORT} -p ${SSH_PORT} ${SSH_HOST}"
 
function report {
    MSG=$1
    if [ -n "${VERBOSE}" ]; then
        echo $MSG
    fi
}
 
function enableProxy {
    ${SSH_CMD} ${SSH_DEBUG_OPTS} 2> ${LOG_FILE}
    showStatus
}
 
function disableProxy {
    ps -ax | grep "${SSH_CMD}" | grep -v grep | awk '{print $1}'| xargs kill
    showStatus
}
 
function showStatus {
    ps -ax | grep "ssh " | grep -v grep
    ps -ax | grep "${SSH_CMD}" | grep -v grep > /dev/null
    if [ $? -eq 0 ]; then
        echo SSH SOCKS Proxy: ON
    else
        echo SSH SOCKS Proxy: OFF
    fi
}
 
case "$1" in
 
    on) report "Enabling Proxy"
        enableProxy
        ;;
 
    off)    report "Disabling Proxy"
        disableProxy
        ;;
 
    status) echo status
        showStatus
        ;;
    *) echo Options: 
       echo "    on        enable proxy"
       echo "    off       disable proxy"
       echo "    status    see proxy status"
esac

