#!/bin/bash

SHELL_DIR="$(dirname $0)"
event="{}"

GREEN='\033[0;32m'
NC='\033[0m' # No Color

handler="index.handler"

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
    --stdin ) STDIN=true; shift ;; # use stdin as event
    --http ) HTTP_MODE=true; shift ;; 
    -- ) shift; break ;;
    "" ) break ;;
    * ) echo -e "\n\t Please use the long and short parameter mode. \n\t For more details, please refer to https://github.com/aliyun/fc-docker. \n\n"; exit -1 ;;
  esac
done

agentPath="${SHELL_DIR}/${AGENT_SCRIPT:-agent.sh}"
requestId="$(cat /proc/sys/kernel/random/uuid)"

hostLimit="$(free -m | awk 'NR==2{printf $2 }')"
dockerLimit="$[$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) / 1024 / 1024]"
# min(hostLimit, dockerLimit)
memoryLimit=$([ $hostLimit -le $dockerLimit ] && echo $hostLimit || echo $dockerLimit)
serverPort=${FC_SERVER_PORT:-9000}

# used for java runtime
export fc_max_server_heap_size="$[ memoryLimit / 10 * 9 ]m"
export fc_min_server_heap_size="10m"

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

curlUtil() {
    curl -s -X POST $3 localhost:${serverPort}/$1 \
        -H "Content-Type: application/octet-stream" \
        -H "Expect: " \
        -H "x-fc-request-id: $requestId" \
        -H "x-fc-function-name: ${FC_FUNCTION_NAME:-fc-docker}" \
        -H "x-fc-function-memory: ${memoryLimit}" \
        -H "x-fc-function-timeout: ${timeout}" \
        -H "x-fc-initialization-timeout: ${initializationTimeout}" \
        -H "x-fc-function-initializer: ${initializer}" \
        -H "x-fc-function-handler: ${handler}" \
        -H "x-fc-access-key-id: ${FC_ACCESS_KEY_ID}" \
        -H "x-fc-access-key-secret: ${FC_ACCESS_KEY_SECRET}" \
        -H "x-fc-security-token: ${FC_SECURITY_TOKEN}" \
        -H "${HTTP_PARAMS_HEADER}" \
        --data-binary "$2"
}

if [ -n "$initializer" ]; then
    curlUtil initialize ""
fi

HTTP_PARAMS_HEADER="${FC_HTTP_PARAMS:+x-fc-http-params: $FC_HTTP_PARAMS}"

# use stdin as event
if [ -n "$STDIN" ]; then 
    # display http response headers and body
    if [ -n "$HTTP_MODE" ]; then
        RESPONSE=$(curlUtil invoke @- '-i')
    else 
        curlUtil invoke @-
    fi
else 
    if [ -n "$HTTP_MODE" ]; then
        RESPONSE=$(curlUtil invoke $event '-i')
    else 
        curlUtil invoke "$event"
    fi
fi


endTimestamp="$(date '+%s')$(date '+%N')"
memoryUsage=$[$(cat /sys/fs/cgroup/memory/memory.usage_in_bytes) / 1024 / 1024]

billedTime=$[(endTimestamp - startTimestamp) / 1000000]

echo -e "\n\n${GREEN}RequestId: ${requestId} \t Billed Duration: ${billedTime} ms \t Memory Size: ${memoryLimit} MB \t Max Memory Used: ${memoryUsage} MB${NC}\n"

if [ -n "$HTTP_MODE" ]; then
    echo "--------------------response begin-----------------"
    echo "$RESPONSE" | base64
    echo "--------------------response end-----------------"

    echo "--------------------execution info begin-----------------"
    echo -e "${requestId}\n${billedTime}\n${memoryLimit}\n${memoryUsage}" | base64
    echo "--------------------execution info end-----------------"
fi

# kill all child process before exit.
# pkill -SIGINT -P "$(jobs -p)"

# wait 