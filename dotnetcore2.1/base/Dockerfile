FROM registry.cn-beijing.aliyuncs.com/aliyunfc/runtime-dotnetcore2.1:dev-v3

LABEL maintainer="alibaba-serverless-fc"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY commons/debian-stretch-sources.list /etc/apt/sources.list

# FC runtime dir path
ARG FC_RUNTIME_PATH=/var/fc/runtime

ENV FC_SERVER_PATH=/var/fc/runtime/dotnetcore2.1
ENV FC_SERVER_PORT=9000 \
    FC_SERVER_CAM_PORT=10080 \
    FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log \
    FC_SERVER_LOG_LEVEL=info

EXPOSE ${FC_SERVER_PORT}

ENV FC_FUNC_CODE_PATH=/code/ \
    FC_RUNTIME_ROOT_PATH=${FC_SERVER_PATH}/bootstrap \
    FC_RUNTIME_SYSTEM_PATH=${FC_SERVER_PATH}

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}lib:${FC_FUNC_CODE_PATH}runtimes/linux-x64/native \
    PATH=${FC_FUNC_CODE_PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create function directories.
RUN mkdir -p \
    ${FC_FUNC_CODE_PATH} \
    ${FC_RUNTIME_ROOT_PATH} \
    ${FC_RUNTIME_SYSTEM_PATH}

# Change work directory.
WORKDIR ${FC_SERVER_PATH}

RUN mkdir -p ${FC_SERVER_LOG_PATH}
RUN chmod 777 ${FC_SERVER_LOG_PATH}
RUN chmod -R 777 /tmp/

# Generate usernames
RUN for i in $(seq 10000 10999); do \
    echo "user$i:x:$i:$i::/tmp:/usr/sbin/nologin" >> /etc/passwd; \
    done

ENV SystemLogLevel=TRACE
ENV FcDotnetHttpUseLiteServer=true

# Start a shell by default
CMD ["bash"]