ARG TAG="latest"
FROM aliyunfc/runtime-php7.2:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl http://cli.so/ca_tgz/php7.2.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/php7.2/mock
COPY php7.2/run/agent.sh /var/fc/runtime/php7.2/agent.sh

ENV AGENT_SCRIPT=agent.sh

ENTRYPOINT ["/var/fc/runtime/php7.2/mock"]
