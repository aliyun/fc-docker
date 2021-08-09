ARG TAG="latest"
FROM aliyunfc/runtime-nodejs10:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl https://aliyun-fc-docker.oss-cn-shanghai.aliyuncs.com/nodejs10.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

RUN apt-get update && apt-get install -y nfs-common --no-install-recommends && rm -r /var/lib/apt/lists/*

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs10/mock
COPY commons/nodejs-agent.sh /var/fc/runtime/nodejs10/agent.sh

ENTRYPOINT ["/var/fc/runtime/nodejs10/mock"]
