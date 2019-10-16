ARG TAG="latest"
FROM aliyunfc/runtime-python2.7:${TAG}

ENV PYTHONUNBUFFERED=1

RUN pip install ptvsd
RUN pip install pydevd

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/python2.7.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/python2.7/mock
COPY python2.7/run/agent.sh /var/fc/runtime/python2.7/agent.sh

ENTRYPOINT ["/var/fc/runtime/python2.7/mock"]
