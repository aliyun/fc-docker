FROM registry.cn-beijing.aliyuncs.com/aliyunfc/runtime-java11:dev-v6

LABEL maintainer="alibaba-serverless-fc"

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY commons/debian-buster-sources.list /etc/apt/sources.list

EXPOSE ${FC_SERVER_PORT}

ENV FC_FUNC_CODE_PATH=/code/ \
    FC_RUNTIME_ROOT_PATH=${FC_SERVER_PATH}/bootstrap \
    FC_RUNTIME_SYSTEM_PATH=${FC_SERVER_PATH}

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib \
    PATH=${FC_FUNC_CODE_PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && apt-get install -y curl && rm -r /var/lib/apt/lists/*

RUN curl -o /tmp/ffmpeg.tar.gz https://lambda-public.oss-cn-hangzhou.aliyuncs.com/runtime/ffmpeg.tar.gz \
    && tar -xzf /tmp/ffmpeg.tar.gz -C /usr/local/bin \
    && rm -rf /tmp/ffmpeg.tar.gz

# Create function directories.
RUN mkdir -p \
    ${FC_FUNC_CODE_PATH} \
    ${FC_RUNTIME_ROOT_PATH} \
    ${FC_RUNTIME_SYSTEM_PATH}

# Set home working directory.
WORKDIR ${FC_FUNC_CODE_PATH}

#set async logger
ENV Log4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector

# Enable CDS
RUN /usr/bin/java -Xshare:dump
