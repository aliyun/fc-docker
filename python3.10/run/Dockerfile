ARG TAG="latest"
FROM aliyunfc/runtime-python3.10:${TAG}

ENV PYTHONUNBUFFERED=1
ENV FC_RUNTIME=python3.10

RUN pip install ptvsd -i https://mirrors.aliyun.com/pypi/simple/
RUN pip install pydevd -i https://mirrors.aliyun.com/pypi/simple/


COPY commons/function-compute-mock-2.0.sh /var/fc/runtime/mock

ENV FC_RIE_VERSION 0.0.3

RUN cd /var/fc/runtime/python3.10 \
    && curl -o /tmp/fc-rie-v${FC_RIE_VERSION}.tar.gz https://fc-runtime-public.oss-cn-hangzhou.aliyuncs.com/fc-rie-v${FC_RIE_VERSION}.tar.gz \
    && tar xf /tmp/fc-rie-v${FC_RIE_VERSION}.tar.gz -C /var/fc/runtime/ \
    && rm /tmp/fc-rie-v${FC_RIE_VERSION}.tar.gz

WORKDIR /var/fc/runtime

ENTRYPOINT ["/var/fc/runtime/mock"]
