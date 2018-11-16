#!/usr/bin/bash
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
        for ent in $(/usr/bin/env | /usr/bin/grep FC_); do
            key=$(echo $ent | /usr/bin/cut -d= -f1)
            value=$(echo $ent | /usr/bin/cut -d= -f2)
            eval "$(echo $key | /usr/bin/tr 'A-Z' 'a-z')=$value"
        done

        # Since java doesn't have a way to unset environment vars, we unset them here.
        for ent in $(/usr/bin/env | /usr/bin/grep FC_ | /usr/bin/grep -v FC_FUNC_CODE_PATH); do
            key=$(echo $ent | /usr/bin/cut -d= -f1)
            unset $key
        done

        /usr/bin/java ${DEBUG_OPTIONS} -cp ${fc_runtime_root_path}/*:${fc_runtime_root_path} \
             -Dlog4j.configurationFile=${fc_server_path}/fc-cagent-log4j2.xml \
             -Dfc.runtime.system.path=${fc_runtime_system_path} \
             -Dfc.func.code.path=${fc_func_code_path} \
             -Dfile.encoding=UTF-8 \
             -Dsun.jnu.encoding=UTF-8 \
             -Dfc.server.log.path=${fc_server_log_path} \
             -Xmx${fc_max_server_heap_size} -Xms${fc_min_server_heap_size} \
             -Dsun.net.httpserver.idleInterval=3600  \
             aliyun.serverless.runtime.ContainerAgent
        ;;
    "help")
        Help
        ;;
    *)
        Help
        ;;
esac
