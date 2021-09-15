ARG TAG="latest"
FROM aliyunfc/runtime-nodejs6:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl https://aliyunfc-docker.oss-cn-shanghai.aliyuncs.com/nodejs6.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

RUN apt-get update && apt-get install -y nfs-common --no-install-recommends && rm -r /var/lib/apt/lists/*

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs6/mock
COPY commons/nodejs-agent.sh /var/fc/runtime/nodejs6/agent.sh


ENTRYPOINT ["/var/fc/runtime/nodejs6/mock"]
