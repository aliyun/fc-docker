# # aliyunfc/fc-runtime:python27-stretch-base see commons directory
# FROM aliyunfc/fc-runtime:python27-stretch-base

# COPY commons/pip.conf /etc/pip.conf

# # Install third party libraries for user function.
# RUN pip install -U pip setuptools 

# # fc-docker fix: as online
# COPY python2.7/base/requirements.txt ./requirements.txt
# RUN pip install -r requirements.txt  --ignore-installed -i https://mirrors.aliyun.com/pypi/simple/
# RUN rm ./requirements.txt

# # iot sdk support 6.1.0
# RUN curl --connect-timeout 60  -m 3600 -fsSL http://lambda-public.oss-cn-hangzhou.aliyuncs.com/lambda/aliyunsdkiot_py2_v20170420.tar.gz | tar -xzC /usr/local/lib/python2.7/dist-packages/aliyunsdkiot/request/

# # Change work directory.
# WORKDIR ${FC_FUNC_CODE_PATH}

# # Server path.
# ENV FC_SERVER_PATH=/var/fc/runtime/python2.7
# ENV FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log
# # Create directory.
# RUN mkdir -p ${FC_SERVER_LOG_PATH}
# ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

# # Start a shell by default
# CMD ["bash"]

FROM aliyunfc/runtime-python2.7:base-1.10.8
COPY ./commons/debian-stretch-sources.list /etc/apt/sources.list