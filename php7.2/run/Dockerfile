ARG TAG="latest"
FROM aliyunfc/runtime-php7.2:${TAG}

RUN rm -rf /var/runtime /var/lang && \
  curl https://aliyun-fc-docker.oss-cn-shanghai.aliyuncs.com/php7.2.tgz | tar -zx -C / && \
  rm -rf /var/fc/runtime/*/var/log/*

COPY commons/function-compute-mock.sh /var/fc/runtime/php7.2/mock
COPY php7.2/run/agent.sh /var/fc/runtime/php7.2/agent.sh

ENV AGENT_SCRIPT=agent.sh

# for xdebug
COPY php7.2/run/xdebug-2.6.1.tgz /var/fc/runtime/php7.2/xdebug-2.6.1.tgz
RUN cd /var/fc/runtime/php7.2 \
  && tar -xvzf xdebug-2.6.1.tgz \
  && cd xdebug-2.6.1 \
  && phpize \
  && ./configure \
  && make \
  && cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20170718 

ENTRYPOINT ["/var/fc/runtime/php7.2/mock"]
