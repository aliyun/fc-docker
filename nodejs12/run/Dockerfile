ARG TAG="latest"
FROM aliyunfc/runtime-nodejs12:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl https://aliyun-fc-docker.oss-cn-shanghai.aliyuncs.com/nodejs12.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

RUN apt-get update && apt-get install -y nfs-common --no-install-recommends && rm -r /var/lib/apt/lists/*

COPY commons/function-compute-mock.sh /var/fc/runtime/nodejs12/mock
COPY commons/nodejs-agent.sh /var/fc/runtime/nodejs12/agent.sh

ENTRYPOINT ["/var/fc/runtime/nodejs12/mock"]
