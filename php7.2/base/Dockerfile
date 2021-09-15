FROM registry.cn-beijing.aliyuncs.com/aliyunfc/runtime-php7.2:dev-v20

LABEL maintainer="alibaba-serverless-fc"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY commons/debian-jessie-sources.list /etc/apt/sources.list

ENV FC_SERVER_PATH=/var/fc/runtime/php7.2

ENV FC_SERVER_PORT=9000 \
    FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log \
    FC_SERVER_LOG_LEVEL=INFO

RUN mkdir -p ${FC_SERVER_LOG_PATH}
RUN chmod 777 ${FC_SERVER_LOG_PATH}
RUN chmod -R 777 /tmp/

ENV FC_FUNC_CODE_PATH=/code/ \
    FC_FUNC_LOG_PATH=/var/log/fc/

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib
ENV PHP_INI_SCAN_DIR=/usr/local/etc/php/conf.d:${FC_FUNC_CODE_PATH}extension

RUN mkdir -p \
    ${FC_SERVER_PATH} \
    ${FC_SERVER_LOG_PATH}

# Expose the port number.
EXPOSE ${FC_SERVER_PORT}

# Set home working directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Start a shell by default
CMD ["bash"]
