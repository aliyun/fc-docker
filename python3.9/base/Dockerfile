# aliyunfc/fc-runtime:python39-stretch-base see commons directory
FROM aliyunfc/fc-runtime:python39-stretch-base

COPY commons/pip.conf /etc/pip.conf

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Install third party libraries for user function.
RUN pip install -U pip -U setuptools

# fc-docker fix: as online
COPY python3.9/base/requirements.txt ./requirements.txt
RUN pip install -r requirements.txt  -i https://mirrors.aliyun.com/pypi/simple/
RUN rm ./requirements.txt

# iot sdk support 6.1.0
RUN curl --connect-timeout 60  -m 3600 -fsSL http://lambda-public.oss-cn-hangzhou.aliyuncs.com/lambda/aliyunsdkiot_py3_v20170420.tar.gz | tar -xzC /usr/local/lib/python3.9/site-packages/aliyunsdkiot/request/

# Server path.
ENV FC_SERVER_PATH=/var/fc/runtime/python3
ENV FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log
# Create directory.
RUN mkdir -p ${FC_SERVER_LOG_PATH}
ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

# Install libopencv-dev
RUN apt-get update \
    && apt-get install -y libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

# Start a shell by default
CMD ["bash"]

