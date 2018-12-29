FROM aliyunfc/runtime-java8:base

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/java8.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/java8/mock.sh
COPY java8/run/agent.sh /var/fc/runtime/java8/agent.sh


ENTRYPOINT ["/var/fc/runtime/java8/mock.sh"]
