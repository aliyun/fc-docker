FROM aliyunfc/runtime-python3.6:build

RUN rm -rf /var/runtime /var/lang && \
  curl https://my-fc-testt.oss-cn-shanghai.aliyuncs.com/python3.6.tgz | tar -zx -C /

COPY commons/function-compute-mock.sh /var/fc/runtime/python3/mock.sh
COPY commons/agent.sh /var/fc/runtime/python3/agent.sh

ENTRYPOINT ["/var/fc/runtime/python3/mock.sh"]
