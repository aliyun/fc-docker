FROM aliyunfc/runtime-nodejs6:base

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/nodejs6.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs6/mock.sh
COPY nodejs6/run/agent.sh /var/fc/runtime/nodejs6/agent.sh


ENTRYPOINT ["/var/fc/runtime/nodejs6/mock.sh"]
