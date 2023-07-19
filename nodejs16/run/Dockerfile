ARG TAG="latest"
FROM aliyunfc/runtime-nodejs16:${TAG}

RUN echo "update222222"

RUN rm -rf /var/runtime /var/lang && \
  curl https://serverless-devs-tool.oss-cn-hongkong.aliyuncs.com/ca_tgz/nodejs16.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs16/mock
COPY commons/nodejs-agent.sh /var/fc/runtime/nodejs16/agent.sh

ENTRYPOINT ["/var/fc/runtime/nodejs16/mock"]
