ARG TAG="latest"
FROM aliyunfc/runtime-go1:${TAG}
ENV FC_RUNTIME=go1
ENV FC_RIE_VERSION=0.0.2

COPY commons/function-compute-mock-2.0.sh /var/fc/runtime/go1/mock
RUN cd /var/fc/runtime/go1 &&
    curl -o /tmp/fc-rie.tar.gz https://fc-runtime-public.oss-cn-hangzhou.aliyuncs.com/fc-rie-v${FC_RIE_VERSION}.tar.gz &&
    tar xf /tmp/fc-rie.tar.gz -C /var/fc/runtime/go1/ &&
    rm /tmp/fc-rie.tar.gz

WORKDIR /var/fc/runtime/go1

ENTRYPOINT ["/var/fc/runtime/go1/mock"]
