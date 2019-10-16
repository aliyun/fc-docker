ARG TAG="latest"
FROM aliyunfc/runtime-python3.6:${TAG}

ENV PYTHONUNBUFFERED=1

RUN pip install ptvsd
RUN pip install pydevd

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/python3.6.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/python3/mock
COPY python3.6/run/agent.sh /var/fc/runtime/python3/agent.sh

ENTRYPOINT ["/var/fc/runtime/python3/mock"]
