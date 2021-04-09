#!/bin/bash

# need CXAPP for ide server download
export ADMIN_HOME="/home/admin"
export BI_DIR_ROOT="${ADMIN_HOME}/.cide"

if [[ "${CXAPP}" = "" ]]; then
    echo "[ERROR] CXAPP must be provide"
    exit 1
fi

export CXAPP_HOME="${ADMIN_HOME}/${CXAPP}"
export LOG_DIR="${CXAPP_HOME}/logs"

begin_action(){
    echo "[INFO] `date`"
    echo "[INFO] change directory owner first"
    sudo chown admin.admin ${BI_DIR_ROOT} ${ADMIN_HOME}/workspace ${CXAPP_HOME}
    mkdir -p ${BI_DIR_ROOT}
    mkdir -p ${LOG_DIR}

    if [[ ! -f ${BI_DIR_ROOT}/.workspace ]]; then
        > ${BI_DIR_ROOT}/.workspace
    fi
    if [[ ! -d ${BI_DIR_ROOT}/.versions ]]; then
        mkdir -p ${BI_DIR_ROOT}/.versions
    fi
    cd ${CXAPP_HOME}
    echo "[INFO] switch directory to: `pwd`"
}

get_version(){
    echo "[INFO] `cat ${ADMIN_HOME}/version.info`"
    local check_sum=`cat ${ADMIN_HOME}/version.info | grep md5 |awk '{print $2}'`
    cat "${ADMIN_HOME}/version.info" > ${BI_DIR_ROOT}/.versions/${CXAPP}.info
    sed -i '/^'${CXAPP}'_version=/d' ${BI_DIR_ROOT}/.workspace
    echo "${CXAPP}_version=${check_sum}" >> ${BI_DIR_ROOT}/.workspace
}

end_action(){
    echo "[INFO] begin start application"
    if [[ -f /etc/profile ]]; then
        source /etc/profile
    fi
    if [[ -f ~/.bash_profile ]]; then
        source ~/.bash_profile
    fi
    if [[ -f ~/.bashrc ]]; then
        source ~/.bashrc
    fi
    
    echo "[INFO] PATH=${PATH}"
    # 启动命令，常驻1号进程，持续保留终端输出
    echo "[INFO] `date`"
    if [[ -f ${CXAPP_HOME}/bin/start.sh ]]; then
        source ${CXAPP_HOME}/bin/start.sh 2>&1
    else
        echo "[ERROR] nothing to execute"
        exit 1
    fi
}


#==================================================================
# main process
#==================================================================
begin_action
get_version
end_action 2>&1 | tee ${LOG_DIR}/run.log