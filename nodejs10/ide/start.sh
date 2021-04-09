#!/bin/bash

cd ${CXAPP_HOME}/${CXAPP}
mkdir -p ${CXAPP_HOME}/aone-ide/plugins/
mkdir -p ${CXAPP_HOME}/${CXAPP}/plugins/

if [[ "${PRE_START_ACTION_URL}" != "" ]]; then
    mkdir -p /home/admin/bin/pre_start.sh
    curl -s --connect-timeout 5 -m 10 -o /home/admin/bin/pre_start.sh "${PRE_START_ACTION_URL}"
    chmod 755 /home/admin/bin/pre_start.sh
    /bin/bash /home/admin/bin/pre_start.sh || exit 1
fi

if [[ "${MAVEN_SETTINGS_URL}" != "" ]]; then
    mkdir -p /home/admin/.m2
    curl -s --connect-timeout 5 -m 10 -o /home/admin/.m2/settings.xml "${MAVEN_SETTINGS_URL}"
fi


/home/admin/.tnvm/versions/node/${IDE_NODE_VERSION}/bin/node \
    ${CXAPP_HOME}/${CXAPP}/browser-app/src/backend/main.js -h 0.0.0.0 -p 50998 --plugins=local-dir:${CXAPP_HOME}/${CXAPP}/plugins/ 2>&1