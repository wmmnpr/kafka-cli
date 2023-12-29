#!/bin/bash

if [[ -z "$BOOTSTRAP_SERVER" ]] && [[ ! -z "$CREATE_TOPICS" ]]; then
    echo "Missing required environment variable: BOOTSTRAP_SERVER (e.g. 'kafka:9092')"
fi

if [[ -z "$BOOTSTRAP_SERVER" ]]; then
    exec "$@"
fi

if [[ -z "$START_TIMEOUT" ]]; then
    START_TIMEOUT=180
fi

start_timeout_exceeded=false
count=0
step=10

until nc -z ${BOOTSTRAP_SERVER}; do
    echo "waiting for kafka to be ready"
    sleep $step;
    count=$((count + step))
    if [ $count -gt $START_TIMEOUT ]; then
        start_timeout_exceeded=true
        break
    fi
done

if $start_timeout_exceeded; then
    echo "Could not connect to kafka within $START_TIMEOUT seconds"
    exit 1
fi


if [[ ! -z "$CREATE_TOPICS" ]]; then
    /opt/create_topics.sh
fi

exec "$@"
