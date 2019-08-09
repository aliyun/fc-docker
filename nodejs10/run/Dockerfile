FROM aliyunfc/runtime-nodejs10:base-1.5.7

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/nodejs10.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs10/mock.sh
COPY commons/nodejs-agent.sh /var/fc/runtime/nodejs10/agent.sh

ENTRYPOINT ["/var/fc/runtime/nodejs10/mock.sh"]
