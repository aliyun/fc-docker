# aliyunfc/fc-runtime:python39-stretch-base see commons directory
FROM aliyunfc/fc-runtime:python39-stretch-base

COPY commons/pip.conf /etc/pip.conf

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Install dev dependencies.
RUN pip install coverage debugpy -i https://mirrors.aliyun.com/pypi/simple/

# Install third party libraries for user function.
RUN pip install -U six
RUN pip install -U pip && pip install -U setuptools

# fc-docker fix: cprotobuf 0.1.10, dependency of pydatahub, could not be installed, so using 0.1.9
RUN pip install --user cython -i https://mirrors.aliyun.com/pypi/simple/
RUN pip install --user \
	scipy \
	numpy \
	wand \
	opencv-python \
	matplotlib \
	scrapy \
	cbor \
	aliyun-fc==0.6 \
	meinheld==0.6.1 \
	aliyun-fc2==2.3.0 \
	tablestore==5.1.0 \
	aliyun-python-sdk-core-v3==2.13.11 \
	aliyun-python-sdk-iot==7.8.0 \
	aliyun-python-sdk-ecs==4.10.1 \
	aliyun-python-sdk-vpc==3.0.2 \
	aliyun-python-sdk-rds==2.1.4 \
	aliyun-python-sdk-kms==2.5.0 \
	aliyun-python-sdk-imm==1.3.4 \
	aliyun-log-python-sdk==0.6.38 \
	aliyun-python-sdk-ram==3.0.0 \
	aliyun-python-sdk-sts==3.0.0 \
	aliyun-python-sdk-fnf==1.3.0 \
	aliyun-python-sdk-dds==2.0.7 \
	aliyun-mns==1.1.5 \
	aliyun-python-sdk-cdn==3.0.8 \
	oss2==2.9.1 \
	pydatahub==2.11.2 \
	-i https://mirrors.aliyun.com/pypi/simple/

# iot sdk support 6.1.0
RUN curl --connect-timeout 60  -m 3600 -fsSL http://lambda-public.oss-cn-hangzhou.aliyuncs.com/lambda/aliyunsdkiot_py3_v20170420.tar.gz | tar -xzC /root/.local/lib/python3.9/site-packages/aliyunsdkiot/request/

# Server path.
ENV FC_SERVER_PATH=/var/fc/runtime/python3
ENV FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log
# Create directory.
RUN mkdir -p ${FC_SERVER_LOG_PATH}
ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

# Start a shell by default
CMD ["bash"]

