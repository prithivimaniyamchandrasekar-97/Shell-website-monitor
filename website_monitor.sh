#!/usr/bin/env bash

# Shell website monitor -- Initial version
# Author : Prithivi MC
# Date : 26 November 2025

URL="https://google.com" # later we'll make this read from a file
LOG_FILE="./website_monitor.log"
TIMEOUT=10               # Seconds

TIMESTAMP="$(date '+%Y-%m-%d  %H:%M:%S')"

#using curl to get HTTP status code + response time

RESULT=$(curl -o /dev/null -s -w "%{http_code} %{time_total}" --max-time "$TIMEOUT" "&URL)
EXIT_CODE=$?

# IF Curl fails (timeout, dns error, no internet)
if [ $EXIT_CODE -ne 0]; then
    echo "$TIMESTAMP | $URL |  ERROR | curl_exit_code=$EXIT_CODE" | tee -a "$LOG_FILE"
    exit 1
fi

HTTP_CODE=$(echo "$RESULT" | awk '{print $1}')
RESPONE_TIME=$(echo "$RESULT" | awk '{print $2}')

STATUS="UP"
if [ "$HTTP_CODE" -ge 400]; then
    STATUS="DOWN"
fi

LOG_LINE=$TIMESTAMP | $URL | $STATUS | http_code=$HTTP_CODE | response_time=${RESPONSE_TIME}S"
echo "$LOG_LINE" | tee -a "$LOG_FILE"