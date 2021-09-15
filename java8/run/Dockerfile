ARG TAG="latest"
FROM aliyunfc/runtime-java8:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl https://aliyunfc-docker.oss-cn-shanghai.aliyuncs.com/java8.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

RUN apt-get update && apt-get install -y nfs-common --no-install-recommends && rm -r /var/lib/apt/lists/*

COPY commons/function-compute-mock.sh /var/fc/runtime/java8/mock
COPY java8/run/agent.sh /var/fc/runtime/java8/agent.sh

ENTRYPOINT ["/var/fc/runtime/java8/mock"]
