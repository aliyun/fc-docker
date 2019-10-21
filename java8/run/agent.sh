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

        params="${DEBUG_OPTIONS} "
        params+="-cp ${fc_runtime_root_path}/*:${fc_runtime_root_path} "
        if [[ "${fc_enable_log4j_config}" == "true" ]]; then
           params+="-Dlog4j.configurationFile=${fc_server_path}/src/main/resources/log4j2.xml "
        fi
        params+="-Dfc.runtime.system.path=${fc_runtime_system_path} "
        params+="-Dfc.func.code.path=${fc_func_code_path} "
        params+="-Dfile.encoding=UTF-8 "
        params+="-Dsun.jnu.encoding=UTF-8 "
        params+="-Dfc.server.log.path=${fc_server_log_path} "
        params+="-Xmx${fc_max_server_heap_size} -Xms${fc_min_server_heap_size} "

        if [[ "${fc_enable_new_java_ca}" == "true" ]]; then
            params+="-XX:+UseSerialGC "
            params+="-Xshare:auto " # fc-docker fix: fix java http trigger could not debug bug
            params+="-Dfc.enable.debug.java.ca=${fc_enable_debug_java_ca} "
            params+="-Djava.security.egd=file:/dev/./urandom "
            /usr/bin/java $params aliyun.serverless.runtime.http.AliFCAgent
        else
            params+="-Dsun.net.httpserver.idleInterval=3600 "
            /usr/bin/java $params aliyun.serverless.runtime.ContainerAgent
        fi

        ;;
    "help")
        Help
        ;;
    *)
        Help
        ;;
esac
