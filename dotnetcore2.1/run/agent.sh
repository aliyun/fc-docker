#!/bin/bash
CURDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

# Set some default configuration.
export FC_SERVER_PORT=${FC_SERVER_PORT:=9000}
export FC_SERVER_PATH=${FC_SERVER_PATH:=${CURDIR}}
export FC_SERVER_LOG_PATH=${FC_SERVER_LOG_PATH:=${CURDIR}/var/log}
export FC_SERVER_LOG_LEVEL=${FC_SERVER_LOG_LEVEL:=INFO}

export FC_FUNC_CODE_PATH=${FC_FUNC_CODE_PATH:=${CURDIR}}
export FC_FUNC_LOG_PATH=${FC_FUNC_LOG_PATH:=${CURDIR}/var/log}

serverPort=${FC_SERVER_PORT:-9000}
codePath=${FC_FUNC_CODE_PATH:-${CURDIR}}
/usr/bin/dotnet /var/fc/runtime/dotnetcore2.1/bootstrap/Aliyun.Serverless.CA.dll -port ${serverPort} -codepath ${codePath}