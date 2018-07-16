FROM aliyunfc/runtime-python2.7:base

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/python2.7.tgz | tar -zx -C /

COPY commons/function-compute-mock.sh /var/fc/runtime/python2.7/mock.sh
COPY commons/agent.sh /var/fc/runtime/python2.7/agent.sh

ENTRYPOINT ["/var/fc/runtime/python2.7/mock.sh"]
