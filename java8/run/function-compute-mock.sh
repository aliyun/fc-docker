#!/bin/bash

set -e

SHELL_DIR="$(dirname $0)"

GREEN='\033[0;32m'
NC='\033[0m' # No Color

handler="${1:-Handler::handlerRequest}"
agentPath="${SHELL_DIR}/agent.sh"
requestId="$(cat /proc/sys/kernel/random/uuid)"

hostLimit="$(free -m | awk 'NR==2{printf $2 }')"
dockerLimit="$[$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) / 1024 / 1024]"

# min(hostLimit, dockerLimit)
memoryLimit=$([ $hostLimit -le $dockerLimit ] && echo $hostLimit || echo $dockerLimit)

serverPort=${FC_SERVER_PORT:-9000}

export fc_max_server_heap_size="$[ memoryLimit / 10 * 9 ]m"
export fc_min_server_heap_size="10m"

if [ ! -f "$agentPath" ]; then
    echo "error: agent.sh not exist"
    exit 1;
fi

if [ -n "$2" ]; then
    event="$2"
else
    event="{}"
fi

exec "$agentPath" start &

# wait until server started
# link https://stackoverflow.com/questions/9609130/efficiently-test-if-a-port-is-open-on-linux-without-nmap-or-netcat
while ! &>/dev/null </dev/tcp/127.0.0.1/${serverPort}; do
    sleep 0.01;
done

startTimestamp="$(date '+%s')$(date '+%N')"

curl -s -X POST localhost:${serverPort}/invoke \
    -H "Content-Type: application/octet-stream" \
    -H "x-fc-request-id: $requestId" \
    -H "x-fc-function-name: ${FC_FUNCTION_NAME:-fc-docker}" \
    -H "x-fc-function-memory: ${memoryLimit}" \
    -H "x-fc-function-timeout: 3" \
    -H "x-fc-function-handler: ${handler}" \
    -H "x-fc-access-key-id: ${FC_ACCESS_KEY_ID}" \
    -H "x-fc-access-key-secret: ${FC_ACCESS_KEY_SECRET}" \
    -H "x-fc-security-token: ${FC_SECURITY_TOKEN}" \
    --data-binary "$event"

endTimestamp="$(date '+%s')$(date '+%N')"
memoryUsage=$[$(cat /sys/fs/cgroup/memory/memory.usage_in_bytes) / 1024 / 1024]

billedTime=$[(endTimestamp - startTimestamp) / 1000000]

echo -e "\n\n${GREEN}RequestId: ${requestId} \t Billed Duration: ${billedTime} ms \t Memory Size: ${memoryLimit} MB \t Max Memory Used: ${memoryUsage} MB${NC}\n"

# kill all child process before exit.
pkill -SIGINT -P "$(jobs -p)"

wait 