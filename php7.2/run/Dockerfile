
FROM aliyunfc/runtime-php7.2:base

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/php7.2.tgz | tar -zx -C /

COPY commons/function-compute-mock.sh /var/fc/runtime/php7.2/mock.sh

ENV AGENT_SCRIPT=start_server.sh

ENTRYPOINT ["/var/fc/runtime/php7.2/mock.sh"]
