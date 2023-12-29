#!/bin/bash

# Expected format:
#   name:[partitions[:replicas[:cleanup.policy]]]
IFS=","; for topicToCreate in $CREATE_TOPICS; do
    echo "creating topic: $topicToCreate"
    IFS=':' read -r -a topicConfig <<< "$topicToCreate"
    trimmed_name="$(echo -e "${topicConfig[0]}" | sed -e 's/^[[:space:]]*//')"

    config=""
    if [ -n "${topicConfig[3]}" ]; then
        config="--config=cleanup.policy=${topicConfig[3]}"
    fi

    kafka-topics.sh --create --bootstrap-server ${BOOTSTRAP_SERVER} \
		--topic ${trimmed_name} \
		--partitions ${topicConfig[1]:-1} \
		--replication-factor ${topicConfig[2]:-1} \
        ${config}
done