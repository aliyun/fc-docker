#!/bin/bash

SHELL_DIR="$(dirname $0)"
event=""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

handler="index.handler"

timeout=3
memory=128
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
    --event-decode ) EVENT_DECODE=true; shift ;;
    --server) SERVER_MODE=true; shift ;;
    --start) START_RUNTIME=true; shift ;;
    --fast-invoke) FAST_INVOKE=true; shift ;;
    -- ) shift; break ;;
    "" ) break ;;
    * ) echo -e "\n\t Please use the long and short parameter mode. \n\t For more details, please refer to https://github.com/aliyun/fc-docker. \n\n"; exit -1 ;;
  esac
done


agentScript="${AGENT_SCRIPT:-fc-rie}"
agentPath="${SHELL_DIR}/${agentScript}"

if [ ! -f "$agentPath" ]; then
    echo "error: $agentPath not exist"
    exit 1;
fi

#FAST_INVOKE=true
if [ -n "$FAST_INVOKE" ]; then
    exec "$agentPath" --fastInvoke --initializer "$initializer" --initializationTimeout "$initializationTimeout" --handler "$handler" --timeout "$timeout" --event "$event"
    exit 0;
fi

if [ -n "$START_RUNTIME" ]; then
    if [ -n "$SERVER_MODE" ]; then
        exec "$agentPath"
        exit 0;
    else
        exec "$agentPath" &
    fi
fi

requestId="$(cat /proc/sys/kernel/random/uuid)"

hostLimit="$(free -m | awk 'NR==2{printf $2 }')"

dockerLimit=8589934592  #8G, 暂时随机设置的一个值
# docker 20 版本有变更: https://github.com/oracle/docker-images/issues/1939
if [[ -f /sys/fs/cgroup/cgroup.controllers ]]; then
   dockerLimit=8589934592  #8G, 暂时随机设置的一个值
else
   dockerLimit="$[$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes) / 1024 / 1024]"
fi

# min(hostLimit, dockerLimit)
memoryLimit=$([ $hostLimit -le $dockerLimit ] && echo $hostLimit || echo $dockerLimit)
serverPort=${FC_SERVER_PORT:-9000}

# wait until server started
# link https://stackoverflow.com/questions/9609130/efficiently-test-if-a-port-is-open-on-linux-without-nmap-or-netcat
while ! &>/dev/null </dev/tcp/127.0.0.1/${serverPort}; do
    sleep 0.01;
done

startTimestamp="$(date '+%s%N')"

[[ -z ${FC_HANDLER} ]] && handler=${FC_HANDLER}
[[ -z ${FC_TIMEOUT} ]] && timeout=${FC_TIMEOUT}
[[ -z ${FC_INITIALIZER} ]] && initializer=${FC_INITIALIZER}
[[ -z ${FC_MEMORY_SIZE} ]] && memory=${FC_MEMORY_SIZE}
[[ -z ${FC_INITIALIZATION_TIMEOUT} ]] && initializationTimeout=${FC_INITIALIZATION_TIMEOUT}

curlUtil() {
    curl -s -X POST $3 localhost:${serverPort}/$1 \
        -H "Content-Type: application/octet-stream" \
        -H "Expect: " \
        -H "x-fc-request-id: $requestId" \
        -H "x-fc-function-name: ${FC_FUNCTION_NAME:-fc-docker}" \
        -H "x-fc-function-memory: ${memory}" \
        -H "x-fc-function-timeout: ${timeout}" \
        -H "x-fc-initialization-timeout: ${initializationTimeout}" \
        -H "x-fc-function-initializer: ${initializer}" \
        -H "x-fc-function-handler: ${handler}" \
        -H "x-fc-account-id: ${FC_ACCOUNT_ID}" \
        -H "x-fc-region: ${FC_REGION}" \
        -H "x-fc-service-name: ${FC_SERVICE_NAME}" \
        -H "x-fc-service-logproject: ${FC_SERVICE_LOG_PROJECT}" \
        -H "x-fc-service-logstore: ${FC_SERVICE_LOG_STORE}" \
        -H "x-fc-access-key-id: ${FC_ACCESS_KEY_ID}" \
        -H "x-fc-access-key-secret: ${FC_ACCESS_KEY_SECRET}" \
        -H "x-fc-security-token: ${FC_SECURITY_TOKEN}" \
        -H "x-fc-retry-count: 1" \
        -H "${HTTP_PARAMS_HEADER}" \
        --data-binary "$2"
}

#if [ -n "$initializer" ]; then
#    curlUtil initialize ""
#fi
#echo -e "\nFC_HTTP_PARAMS 2: $FC_HTTP_PARAMS\n"

HTTP_PARAMS_HEADER="${FC_HTTP_PARAMS:+x-fc-http-params: $FC_HTTP_PARAMS}"

# use stdin as event
if [ -n "$STDIN" ]; then
    # display http response headers and body
    if [ -n "$HTTP_MODE" ]; then
        RESPONSE=$(curlUtil invoke @- '-i')
    else
        RESPONSE=$(curlUtil invoke @-)
    fi
else
    # event may be empty, must use quotation marks
    if [ -n "$HTTP_MODE" ]; then
        RESPONSE=$(curlUtil invoke "$event" -i)
    else
        if [ -n "$EVENT_DECODE" ]; then
            RESPONSE=$(echo "$event" | base64 -d | curlUtil invoke @-)
        else
            RESPONSE=$(echo "$event" | curlUtil invoke @-)
        fi
#        RESPONSE=$(echo "$event" | curlUtil invoke @-)
    fi
fi

endTimestamp="$(date '+%s%N')"

memoryUsage=32
# docker 20 版本有变更: https://github.com/oracle/docker-images/issues/1939
if [[ -f /sys/fs/cgroup/cgroup.controllers ]]; then
   memoryUsage=$[$(cat /sys/fs/cgroup/memory.current) / 1024 / 1024]
else
   memoryUsage=$[$(cat /sys/fs/cgroup/memory/memory.usage_in_bytes) / 1024 / 1024]
fi

billedTime=$[(endTimestamp - startTimestamp) / 1000000]

echo -e "\n${GREEN}RequestId: ${requestId} \t Billed Duration: ${billedTime} ms \t Memory Size: ${memoryLimit} MB \t Max Memory Used: ${memoryUsage} MB${NC}\n"

if [ -n "$HTTP_MODE" ]; then
    echo "--------------------response begin-----------------"
    echo "$RESPONSE" | base64
    echo "--------------------response end-----------------"

    echo "--------------------execution info begin-----------------"
    echo -e "${requestId}\n${billedTime}\n${memoryLimit}\n${memoryUsage}" | base64
    echo "--------------------execution info end-----------------"
else
    echo -e "${BLUE}FC Local Invoke Result:${NC}"
    echo "$RESPONSE"
    echo -e "\n${BLUE}End of method: invoke${NC}"
fi

# kill all child process before exit.
# pkill -SIGINT -P "$(jobs -p)"

# wait