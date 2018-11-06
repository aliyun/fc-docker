FROM aliyunfc/runtime-nodejs6:base

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/nodejs6.tgz | tar -zx -C /

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs6/mock.sh

ENTRYPOINT ["/var/fc/runtime/nodejs6/mock.sh"]
