ARG TAG="latest"
FROM aliyunfc/runtime-java11:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl https://aliyun-fc-docker.oss-cn-shanghai.aliyuncs.com/java11.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

RUN apt-get update && apt-get install -y nfs-common --no-install-recommends && rm -r /var/lib/apt/lists/*

COPY commons/function-compute-mock.sh /var/fc/runtime/java11/mock
COPY java11/run/agent.sh /var/fc/runtime/java11/agent.sh

# Set home working directory.
WORKDIR ${FC_FUNC_CODE_PATH}

#set async logger
ENV Log4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector

# Enable CDS
RUN /usr/bin/java -Xshare:dump

ENTRYPOINT ["/var/fc/runtime/java11/mock"]
