FROM registry.cn-beijing.aliyuncs.com/aliyunfc/runtime-python3.6:dev-v42

LABEL maintainer="alibaba-serverless-fc"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY commons/debian-jessie-sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y curl && rm -r /var/lib/apt/lists/*

RUN curl -o /tmp/ffmpeg.tar.gz https://lambda-public.oss-cn-hangzhou.aliyuncs.com/runtime/ffmpeg.tar.gz \
    && tar -xzf /tmp/ffmpeg.tar.gz -C /usr/local/bin \
    && rm -rf /tmp/ffmpeg.tar.gz

ARG FC_RUNTIME_PATH=/var/fc/runtime

ENV FC_SERVER_PATH=${FC_RUNTIME_PATH}/python3

ENV FC_SERVER_PORT=9000 \
    FC_SERVER_CAM_PORT=10080 \
    FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log \
    FC_SERVER_LOG_LEVEL=INFO

RUN mkdir -p ${FC_SERVER_LOG_PATH}
RUN chmod 777 ${FC_SERVER_LOG_PATH}
RUN chmod -R 777 /tmp/

ENV FC_FUNC_CODE_PATH=/code/ \
    FC_FUNC_LOG_PATH=/var/log/fc/

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

RUN mkdir -p \
    ${FC_SERVER_PATH} \
    ${FC_SERVER_LOG_PATH}

EXPOSE ${FC_SERVER_PORT}

# Set home working directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Start a shell by default
CMD ["bash"]