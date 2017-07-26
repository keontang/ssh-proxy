#!/bin/bash
## (C) George Goulas, 2011
##
## Proxy service configuration script for OSX
## tested on MacOSX Lion 10.6
##

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 

## SETTINGS
##
# SOCKS PROXY PORT
# Notes: It's the same value with the autoproxy.pac
PORT=1090
# SSH DEBUG OPTIONS
#SSH_DEBUG_OPTS="-vvv"
SSH_DEBUG_OPTS=""
# SSH OPTIONS TO CREATE PROXY
SSH_OPTS="-C2TnNfD"
# user@host
SSH_HOST="gw@foreign.vpn.caicloud.io"
# SSH PORT
SSH_PORT=22
# OSX network service to configure proxy for
NET_INTERFACE="yl"
# Pac file for autoproxy
PAC_FILE="file:/${ROOT_DIR}/autoproxy.pac"
# Verbose, if not empty, it prints diagnosing messages
VERBOSE=1
# Log file for ssh proxy
LOG_FILE="${HOME}/sshproxy.log"
# Set auto proxy configuration off or not
OFF_AUTOPROXY=1
# Bypass proxy settings for hosts and domains
BYPASS_DOMAINS="127.0.0.1 localhost 169.254/16 192.168/16"
##
## END OF SETTINGS, DO NOT MODIFY PAST THIS POINT
##

 

