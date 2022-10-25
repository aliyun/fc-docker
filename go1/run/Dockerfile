ARG TAG="latest"
FROM aliyunfc/runtime-go1:${TAG}

COPY go1/run/function-compute-mock.sh /var/fc/runtime/go1/mock
RUN cd /var/fc/runtime/go1 \
    && curl -o /tmp/fc-rie.tar.gz https://fc-runtime-public.oss-cn-hangzhou.aliyuncs.com/fc-rie.tar.gz \
    && tar xf /tmp/fc-rie.tar.gz -C /var/fc/runtime/go1/ \
    && rm /tmp/fc-rie.tar.gz

WORKDIR /var/fc/runtime/go1

ENTRYPOINT ["/var/fc/runtime/go1/mock"]