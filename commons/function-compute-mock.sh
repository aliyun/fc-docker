#!/bin/bash

set -e

SHELL_DIR="$(dirname $0)"

GREEN='\033[0;32m'
NC='\033[0m' # No Color

handler="${1:-index.handler}"

if [ -n "$2" ]; then
    event="$2"
else
    event="{}"
fi

timeout=3
initializer=
initializationTimeout=3

while true; do
  case "$1" in
    -h | --handler ) handler="$2"; shift 2;;
    -i | --initializer ) initializer="$2"; shift 2;;
    -e | --initializationTimeout ) initializationTimeout="$2"; shift 2 ;;
    --timeout ) timeout="$2"; shift 2 ;;
    --event ) event="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) echo -e "\n\t Please use the long and short parameter mode. \n\t For more details, please refer to https://github.com/aliyun/fc-docker. \n\n"; break ;;
  esac
done

agentPath="${SHELL_DIR}/${AGENT_SCRIPT:-agent.sh}"
requestId="$(cat /proc/sys/kernel/random/uuid)"

hostLimit="$(free -m | awk 'NR==2{printf $2 }')"
dockerLimit="$[$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) / 1024 / 1024]"
memoryLimit=$([ $hostLimit -le $dockerLimit ] && echo $hostLimit || echo $dockerLimit)
serverPort=${FC_SERVER_PORT:-9000}

if [ ! -f "$agentPath" ]; then
    echo "error: agent.sh not exist"
    exit 1;
fi

exec "$agentPath" start &

# wait until server started
# link https://stackoverflow.com/questions/9609130/efficiently-test-if-a-port-is-open-on-linux-without-nmap-or-netcat
while ! &>/dev/null </dev/tcp/127.0.0.1/${serverPort}; do
    sleep 0.01;
done

startTimestamp="$(date '+%s')$(date '+%N')"

if [ -n "$initializer" ]; then
    curl -s -X POST localhost:${serverPort}/initialize \
        -H "Content-Type: application/octet-stream" \
        -H "x-fc-request-id: $requestId" \
        -H "x-fc-function-name: ${FC_FUNCTION_NAME:-fc-docker}" \
        -H "x-fc-function-memory: ${memoryLimit}" \
        -H "x-fc-function-timeout: ${timeout}" \
        -H "x-fc-initialization-timeout: ${initializationTimeout}" \
        -H "x-fc-function-initializer: ${initializer}" \
        -H "x-fc-function-handler: ${handler}" \
        -H "x-fc-access-key-id: ${FC_ACCESS_KEY_ID}" \
        -H "x-fc-access-key-secret: ${FC_ACCESS_KEY_SECRET}" \
        -H "x-fc-security-token: ${FC_SECURITY_TOKEN}"
fi

curl -s -X POST localhost:${serverPort}/invoke \
    -H "Content-Type: application/octet-stream" \
    -H "x-fc-request-id: $requestId" \
    -H "x-fc-function-name: ${FC_FUNCTION_NAME:-fc-docker}" \
    -H "x-fc-function-memory: ${memoryLimit}" \
    -H "x-fc-function-timeout: ${timeout}" \
    -H "x-fc-function-handler: ${handler}" \
    -H "x-fc-initialization-timeout: ${initializationTimeout}" \
    -H "x-fc-function-initializer: ${initializer}" \
    -H "x-fc-access-key-id: ${FC_ACCESS_KEY_ID}" \
    -H "x-fc-access-key-secret: ${FC_ACCESS_KEY_SECRET}" \
    -H "x-fc-security-token: ${FC_SECURITY_TOKEN}" \
    --data-binary "$event"

endTimestamp="$(date '+%s')$(date '+%N')"
memoryUsage=$[$(cat /sys/fs/cgroup/memory/memory.usage_in_bytes) / 1024 / 1024]

billedTime=$[(endTimestamp - startTimestamp) / 1000000]

echo -e "\n\n${GREEN}RequestId: ${requestId} \t Billed Duration: ${billedTime} ms \t Memory Size: ${memoryLimit} MB \t Max Memory Used: ${memoryUsage} MB${NC}\n"

# kill all child process before exit.
# pkill -SIGINT -P "$(jobs -p)"

# wait 