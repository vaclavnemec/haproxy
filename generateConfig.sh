#!/bin/sh

if [ -z "$SERVERS" ]; then
	echo "SERVERS not specified!" 1>&2
    exit 1
fi

if [ -z "$MAX_CONNECTION" ]; then
    MAX_CONNECTION="1024"
fi

if [ -z "$TIMEOUT_CONNECTION" ]; then
    TIMEOUT_CONNECTION="5000ms"
fi

if [ -z "$TIMEOUT_CLIENT" ]; then
    TIMEOUT_CLIENT="50000ms"
fi

if [ -z "$TIMEOUT_SERVER" ]; then
    TIMEOUT_SERVER="50000ms"
fi

if [ -z "$COOKIE" ]; then
    COOKIE="SERVER_NODE"
fi

if [ -z "$SERVER_MAX_CONNECTION" ]; then
    SERVER_MAX_CONNECTION="256"
fi

cat  << EOF
global
    daemon
    maxconn $MAX_CONNECTION

defaults
    mode http
    timeout connect $TIMEOUT_CONNECTION
    timeout client $TIMEOUT_CLIENT
    timeout server $TIMEOUT_SERVER

frontend http-in
    bind *:80
    default_backend vendavo

backend vendavo
    cookie $COOKIE insert indirect nocache
EOF
printf $SERVERS | awk -v server_max_connection="$SERVER_MAX_CONNECTION" -F ':' 'BEGIN { RS = ";" } ; { print "    server",$1"-"NR,$1":"$2" maxconn",server_max_connection,"check cookie",$1"-"NR }'
echo
