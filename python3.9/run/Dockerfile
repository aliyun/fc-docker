ARG TAG="latest"
FROM aliyunfc/runtime-python3.9:${TAG}

ENV PYTHONUNBUFFERED=1

RUN pip install ptvsd -i https://mirrors.aliyun.com/pypi/simple/
RUN pip install pydevd -i https://mirrors.aliyun.com/pypi/simple/

RUN rm -rf /var/runtime /var/lang && \
  curl http://cli.so/ca_tgz/python3.9.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/python3/mock
COPY python3.9/run/agent.sh /var/fc/runtime/python3/agent.sh

ENTRYPOINT ["/var/fc/runtime/python3/mock"]
