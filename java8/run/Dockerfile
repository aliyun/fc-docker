FROM aliyunfc/runtime-java8:base

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/java8.tgz | tar -zx -C /

COPY java8/run/function-compute-mock.sh /var/fc/runtime/java8/mock.sh

ENTRYPOINT ["/var/fc/runtime/java8/mock.sh"]
