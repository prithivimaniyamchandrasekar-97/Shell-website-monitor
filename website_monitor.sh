#!/usr/bin/env bash

# Website Monitor - Single website version
# Author: <your-name>
# Date: 2025-11-26

URL="https://google.com"   # Later we will make this read from a file
LOG_FILE="./website_monitor.log"
TIMEOUT=10                 # seconds

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# Using curl to get HTTP status code + response time
RESULT=$(curl -o /dev/null -s -w "%{http_code} %{time_total}" --max-time "$TIMEOUT" "$URL")
EXIT_CODE=$?

# If curl fails (timeout, DNS error, no internet)
if [ $EXIT_CODE -ne 0 ]; then
    echo "$TIMESTAMP | $URL | ERROR | curl_exit_code=$EXIT_CODE" | tee -a "$LOG_FILE"
    exit 1
fi

HTTP_CODE=$(echo "$RESULT" | awk '{print $1}')
RESPONSE_TIME=$(echo "$RESULT" | awk '{print $2}')

STATUS="UP"
if [ "$HTTP_CODE" -ge 400 ]; then
    STATUS="DOWN"
fi

LOG_LINE="$TIMESTAMP | $URL | $STATUS | http_code=$HTTP_CODE | response_time=${RESPONSE_TIME}s"
echo "$LOG_LINE" | tee -a "$LOG_FILE"