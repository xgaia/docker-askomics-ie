#!/bin/bash
while true; do
    sleep 1m
    if [ `netstat -t | grep -v CLOSE_WAIT | grep ':6543' | wc -l` -lt 3 ]
    then
        pkill python3
    fi
done
