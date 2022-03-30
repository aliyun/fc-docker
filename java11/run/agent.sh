#!/bin/bash
###################################################################
# To start the java server, use this script.
####################################################################

Help() {
    echo "Usage:"
    echo "      $0 command"
    echo "Commands"
    echo "      start               start up server"
    echo "      help                print help page"
}


if [ $# -eq 0 ]
then
    echo "Missing arguments."
    Help
    exit 0;
fi

command=$1
case ${command} in
    "start")
        # Save FC_* vars in local vars with keys lower-cased
        for ent in $(/usr/bin/env | /bin/grep FC_); do
            key=$(echo $ent | /usr/bin/cut -d= -f1)
            value=$(echo $ent | /usr/bin/cut -d= -f2)
            eval "$(echo $key | /usr/bin/tr 'A-Z' 'a-z')=$value"
        done

        # Since java doesn't have a way to unset environment vars, we unset them here.
        for ent in $(/usr/bin/env | /bin/grep FC_ | /bin/grep -v FC_FUNC_CODE_PATH); do
            key=$(echo $ent | /usr/bin/cut -d= -f1)
            unset $key
        done

        params="${DEBUG_OPTIONS} "
        params+="-cp ${fc_runtime_root_path}/*:${fc_runtime_root_path} "
        params+="-Dfc.runtime.system.path=${fc_runtime_system_path} "
        params+="-Dfc.func.code.path=${fc_func_code_path} "
        params+="-Dfile.encoding=UTF-8 "
        params+="-Dsun.jnu.encoding=UTF-8 "
        params+="-Dfc.server.log.path=${fc_server_log_path} "
        params+="-Xmx${fc_max_server_heap_size} -Xms${fc_min_server_heap_size} "

        params+="-XX:+UseSerialGC "
        params+="-Xshare:on "
        params+="-Djava.security.egd=file:/dev/./urandom "
        /usr/bin/java $params aliyun.serverless.runtime.http.AliFCAgent

        ;;
    "help")
        Help
        ;;
    *)
        Help
        ;;
esac
