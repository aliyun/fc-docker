FROM aliyunfc/runtime-python2.7:base

RUN pip install ptvsd

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/python2.7.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/python2.7/mock.sh
COPY python2.7/run/agent.sh /var/fc/runtime/python2.7/agent.sh

ENTRYPOINT ["/var/fc/runtime/python2.7/mock.sh"]
