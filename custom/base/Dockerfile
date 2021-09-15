FROM registry.cn-beijing.aliyuncs.com/aliyunfc/runtime-custom:dev-v16

MAINTAINER alibaba-serverless-fc

COPY commons/debian-stretch-sources.list /etc/apt/sources.list

RUN curl -o /tmp/ffmpeg.tar.gz https://lambda-public.oss-cn-hangzhou.aliyuncs.com/runtime/ffmpeg.tar.gz \
    && tar -xzf /tmp/ffmpeg.tar.gz -C /usr/local/bin \
    && rm -rf /tmp/ffmpeg.tar.gz

ENV FC_SERVER_PORT=9000 \
    FC_FUNC_CODE_PATH=/code

ENV PYTHONPATH=/code

ENV BOOTSTRAP_FILE=bootstrap

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

WORKDIR ${FC_FUNC_CODE_PATH}

# Start a shell by default
CMD ["bash"]
