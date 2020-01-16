#!/bin/bash
CURDIR="$( cd "$( /usr/bin/dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

serverPort=${FC_SERVER_PORT:-9000}
codePath=${FC_FUNC_CODE_PATH:-${CURDIR}}
/usr/bin/dotnet /var/fc/runtime/dotnetcore2.1/bootstrap/Aliyun.Serverless.CA.dll -port ${serverPort} -codepath ${codePath}