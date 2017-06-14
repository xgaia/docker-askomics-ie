#!/bin/bash
while true; do
    sleep 1h # Set to 1h for testing, change to 1m in production mode
    if [ `netstat -t | grep -v CLOSE_WAIT | grep ':6543' | wc -l` -lt 3 ]
    then
        pkill python3
    fi
done
