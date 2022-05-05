ARG TAG="latest"
FROM aliyunfc/runtime-java8:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl http://cli.so/ca_tgz/java8.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/java8/mock
COPY java8/run/agent.sh /var/fc/runtime/java8/agent.sh

ENTRYPOINT ["/var/fc/runtime/java8/mock"]
