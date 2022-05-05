ARG TAG="latest"
FROM aliyunfc/runtime-nodejs8:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl http://cli.so/ca_tgz/nodejs8.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs8/mock
COPY commons/nodejs-agent.sh /var/fc/runtime/nodejs8/agent.sh

ENTRYPOINT ["/var/fc/runtime/nodejs8/mock"]
