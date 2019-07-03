FROM aliyunfc/runtime-python3.6:base-1.5.4

RUN pip install ptvsd

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/python3.6.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/python3/mock.sh
COPY python3.6/run/agent.sh /var/fc/runtime/python3/agent.sh

ENTRYPOINT ["/var/fc/runtime/python3/mock.sh"]
