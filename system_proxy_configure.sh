#!/bin/bash
## (C) George Goulas, 2011
##
## Proxy service configuration script for OSX
## tested on MacOSX Lion 10.6
##

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 
source ${ROOT_DIR}/config.sh

function report {
    MSG=$1
    if [ -n "${VERBOSE}" ]; then
        echo $MSG
    fi
}
 
function enableProxy {
    current_url=$(networksetup -getautoproxyurl ${NET_INTERFACE} | grep URL | awk '{print $2}')
    echo ${current_url}
    if [ "${current_url}" != ${PAC_FILE}  ]; then
        echo Setautoproxyurl: ${PAC_FILE}, for interface: ${NET_INTERFACE}
        networksetup  -setautoproxyurl ${NET_INTERFACE} ${PAC_FILE}
    fi

    current_proxy_port=$(networksetup -getsocksfirewallproxy ${NET_INTERFACE} | grep Port | awk '{print $2}')
    if [ "${current_proxy_port}" != "${PORT}" ]; then
        echo Setsocksfirewallproxy: localhost ${PORT}, for interface: ${NET_INTERFACE}
        networksetup  -setsocksfirewallproxy ${NET_INTERFACE} localhost ${PORT}
    fi
    
    current_bypass=$(networksetup -getproxybypassdomains ${NET_INTERFACE})
    # Change '\n' to ' '
    current_bypass=$(echo ${current_bypass})
    echo "${current_bypass}"
    echo "${BYPASS_DOMAINS}"
    if [ "${current_bypass}" != "${BYPASS_DOMAINS}" ]; then
        echo Setproxybypassdomains: ${BYPASS_DOMAINS}, for interface: ${NET_INTERFACE}
        networksetup  -setproxybypassdomains ${NET_INTERFACE} ${BYPASS_DOMAINS}
    fi    

    networksetup -getautoproxyurl ${NET_INTERFACE} | grep Enabled | grep Yes > /dev/null
    if [ $? -eq 0 ]; then
        echo Autoproxy is already on
    else
        echo Set autoproxystate on
        networksetup  -setautoproxystate ${NET_INTERFACE} on
    fi

    networksetup -getsocksfirewallproxy ${NET_INTERFACE} | grep Enabled | grep Yes > /dev/null
    if [ $? -eq 0 ]; then
        echo Socksfirewallproxy is already on 
    else
        echo Set socksfirewallproxystate on
        networksetup  -setsocksfirewallproxystate ${NET_INTERFACE} on
    fi
}
 
function disableProxy {
    networksetup -getsocksfirewallproxy ${NET_INTERFACE} | grep Enabled | grep Yes > /dev/null
    if [ $? -eq 0 ]; then
        echo Set socksfirewallproxystate off
        networksetup  -setsocksfirewallproxystate ${NET_INTERFACE} off
    else
        echo Socksfirewallproxy is already off
    fi

    if [ "${OFF_AUTOPROXY}" == "1" ]; then
        networksetup -getautoproxyurl ${NET_INTERFACE} | grep Enabled | grep Yes > /dev/null
        if [ $? -eq 0 ]; then
            echo Set autoproxystate off
            networksetup  -setautoproxystate ${NET_INTERFACE} off
        fi
    fi
}
 
function showStatus {
    #networksetup -getsocksfirewallproxy ${NET_INTERFACE} | grep Enabled | grep Yes > /dev/null
    #if [ $? -eq 0 ]; then
    #    echo Socksfirewallproxy for ${NET_INTERFACE}: ON
    #else
    #    echo Socksfirewallproxy for ${NET_INTERFACE}: OFF
    #fi

    networksetup -getautoproxyurl ${NET_INTERFACE} | grep Enabled | grep Yes > /dev/null
    if [ $? -eq 0 ]; then
        echo Autoproxy for ${NET_INTERFACE}: ON
    else
        echo Autoproxy for ${NET_INTERFACE}: OFF
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
       echo "    on        set proxy settings"
       echo "    off       clear proxy settings" 
       echo "    status    see proxy settings"
esac

