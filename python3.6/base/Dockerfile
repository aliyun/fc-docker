# aliyunfc/fc-runtime:python36-stretch-base see commons directory
FROM aliyunfc/fc-runtime:python36-stretch-base

COPY commons/pip.conf /etc/pip.conf

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Install third party libraries for user function.
RUN pip install -U pip setuptools

# fc-docker fix: as online
RUN pip install Cython==0.29.27 incremental==21.3.0  Automat==20.2.0 attrs==21.4.0 constantly==15.1.0 hyperlink==21.0.0 idna==2.7 numpy==1.13.3 zope.interface==5.4.0 six==1.16.0 scipy==1.0.0
COPY python3.6/base/requirements.txt ./requirements.txt
RUN pip install -r requirements.txt  -i https://mirrors.aliyun.com/pypi/simple/
RUN rm ./requirements.txt

# iot sdk support 6.1.0
RUN curl --connect-timeout 60  -m 3600 -fsSL http://lambda-public.oss-cn-hangzhou.aliyuncs.com/lambda/aliyunsdkiot_py3_v20170420.tar.gz | tar -xzC /usr/local/lib/python3.6/site-packages/aliyunsdkiot/request/

# Server path.
ENV FC_SERVER_PATH=/var/fc/runtime/python3
ENV FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log
# Create directory.
RUN mkdir -p ${FC_SERVER_LOG_PATH}
ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

# Start a shell by default
CMD ["bash"]

