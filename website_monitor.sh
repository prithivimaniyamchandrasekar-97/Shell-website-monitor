#!/usr/bin/env bash

# Website Monitor - Single website version
# Author: Prithvi
# Date: 2025-11-26

WEBSITE_LIST="./websites.txt"
LOG_FILE="./website_monitor.log"
TIMEOUT=10

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

if [ ! -f "$WEBSITE_LIST" ]; then
    echo "Website list file not found: $WEBSITE_LIST"
    exit 1
fi

while read -r URL; do

    # Skip empty lines or comments
    if [[ -z "$URL" ]] || [[ "$URL" =~ ^# ]]; then
        continue
    fi

    RESULT=$(curl -o /dev/null -s -w "%{http_code} %{time_total}" --max-time "$TIMEOUT" "$URL")
    EXIT_CODE=$?

    # ALERT if curl failed (timeout, DNS failure, no internet, etc.)
    if [ $EXIT_CODE -ne 0 ]; then
        ALERT_MSG="$TIMESTAMP | ALERT | $URL seems DOWN (curl_exit_code=$EXIT_CODE)"
        echo "$ALERT_MSG" | tee -a "$LOG_FILE"
        continue
    fi

    HTTP_CODE=$(echo "$RESULT" | awk '{print $1}')
    RESPONSE_TIME=$(echo "$RESULT" | awk '{print $2}')

    STATUS="UP"
    if [ "$HTTP_CODE" -ge 400 ]; then
        STATUS="DOWN"
        ALERT_MSG="$TIMESTAMP | ALERT | $URL returned HTTP $HTTP_CODE"
        echo "$ALERT_MSG" | tee -a "$LOG_FILE"
    fi

    LOG_LINE="$TIMESTAMP | $URL | $STATUS | http_code=$HTTP_CODE | response_time=${RESPONSE_TIME}s"
    echo "$LOG_LINE" | tee -a "$LOG_FILE"

done < "$WEBSITE_LIST