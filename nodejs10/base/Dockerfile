FROM  registry.cn-beijing.aliyuncs.com/aliyunfc/runtime-nodejs10:dev-v5

MAINTAINER alibaba-serverless-fc

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY commons/debian-jessie-sources.list /etc/apt/sources.list

ARG FC_RUNTIME_PATH=/var/fc/runtime

ENV FC_SERVER_PORT=9000 \
    FC_SERVER_CAM_PORT=10080 \
    FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log \
    FC_SERVER_LOG_LEVEL=info \
    FC_FUNC_CODE_PATH=/code/ \
    FC_FUNC_LOG_PATH=/var/log/fc/

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib \
    NODE_PATH=/usr/local/lib/node_modules:/opt/nodejs/node10/node_modules:/opt/nodejs/node_modules

RUN mkdir -p \
    ${FC_SERVER_LOG_PATH}

RUN chmod 777 ${FC_SERVER_LOG_PATH}
RUN chmod -R 777 /tmp/

EXPOSE ${FC_SERVER_PORT}

WORKDIR ${FC_FUNC_CODE_PATH}

# Start a shell by default
CMD ["bash"]