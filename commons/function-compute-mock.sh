#!/bin/bash

SHELL_DIR="$(dirname $0)"
event=""

GREEN='\033[0;32m'
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
    -- ) shift; break ;;
    "" ) break ;;
    * ) echo -e "\n\t Please use the long and short parameter mode. \n\t For more details, please refer to https://github.com/aliyun/fc-docker. \n\n"; exit -1 ;;
  esac
done

agentScript="${AGENT_SCRIPT:-agent.sh}"
agentPath="${SHELL_DIR}/${agentScript}"
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

if ! ps aux | grep "$agentScript"  | grep -q -v grep ; then

    if [ -n "$SERVER_MODE" ]; then
        exec "$agentPath" start
        exit 0;
    else
        exec "$agentPath" start &
    fi
fi

# wait until server started
# link https://stackoverflow.com/questions/9609130/efficiently-test-if-a-port-is-open-on-linux-without-nmap-or-netcat
while ! &>/dev/null </dev/tcp/127.0.0.1/${serverPort}; do
    sleep 0.01;
done

startTimestamp="$(date '+%s')$(date '+%N')"

[[ -z ${FC_HANDLER} ]] && handler=${FC_HANDLER}
[[ -z ${FC_TIMEOUT} ]] && timeout=${FC_TIMEOUT}
[[ -z ${FC_INITIALIZER} ]] && initializer=${FC_INITIALIZER}
[[ -z ${FC_MEMORY_SIZE} ]] && memory=${FC_MEMORY_SIZE}
[[ -z ${FC_INITIALIZATIONIMEOUT} ]] && initializationTimeout=${FC_INITIALIZATIONIMEOUT}

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
        -H "x-fc-account-id: ${FC_ACCOUND_ID}" \
        -H "x-fc-region: ${FC_REGION}" \
        -H "x-fc-service-name: ${FC_SERVICE_NAME}" \
        -H "x-fc-service-logproject: ${FC_SERVICE_LOG_PROJECT}" \
        -H "x-fc-service-logstore: ${FC_SERVICE_LOG_STORE}" \
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
        RESPONSE=$(curlUtil invoke @- '-i' | base64)
    else 
        curlUtil invoke @-
    fi
else
    # event may be empty, must use quotation marks
    if [ -n "$HTTP_MODE" ]; then
        if [ -n "$EVENT_DECODE" ]; then
            # why use pipes see https://stackoverflow.com/questions/6570531/assign-string-containing-null-character-0-to-a-variable-in-bash/24511770#24511770
            RESPONSE=$(echo "$event" | base64 -d | curlUtil invoke @- '-i' | base64)
        else
            RESPONSE=$(echo "$event" | curlUtil invoke @- '-i' | base64)
        fi
    else
        if [ -n "$EVENT_DECODE" ]; then
            echo "$event" | base64 -d | curlUtil invoke @-
        else
            echo "$event" | curlUtil invoke @-
        fi
    fi
fi

endTimestamp="$(date '+%s')$(date '+%N')"
memoryUsage=$[$(cat /sys/fs/cgroup/memory/memory.usage_in_bytes) / 1024 / 1024]

billedTime=$[(endTimestamp - startTimestamp) / 1000000]

echo -e "\n\n${GREEN}RequestId: ${requestId} \t Billed Duration: ${billedTime} ms \t Memory Size: ${memoryLimit} MB \t Max Memory Used: ${memoryUsage} MB${NC}\n"

if [ -n "$HTTP_MODE" ]; then
    echo "--------------------response begin-----------------"
    echo "$RESPONSE"
    echo "--------------------response end-----------------"

    echo "--------------------execution info begin-----------------"
    echo -e "${requestId}\n${billedTime}\n${memoryLimit}\n${memoryUsage}" | base64
    echo "--------------------execution info end-----------------"
fi

# kill all child process before exit.
# pkill -SIGINT -P "$(jobs -p)"

# wait