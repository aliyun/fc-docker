FROM python:2.7.13-jessie

MAINTAINER alibaba-serverless-fc

# Server path.
ENV FC_SERVER_PATH=/var/fc/runtime/python2.7

# Create directory.
RUN mkdir -p ${FC_SERVER_PATH}
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

ENV FC_FUNC_CODE_PATH=/code/

COPY commons/pip.conf /etc/pip.conf
COPY commons/debian-jessie-sources.list /etc/apt/sources.list

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Install dev dependencies.
RUN pip install coverage

# Install common libraries
# imagemagick=8:6.9.7.4+dfsg-11+deb9u3 already exist, ignore
RUN apt-get update && apt-get install -y \
        imagemagick \
        libopencv-dev \
        fonts-wqy-zenhei=0.9.45-6 \
        fonts-wqy-microhei=0.2.0-beta-2
        
# Suppress opencv error: "libdc1394 error: Failed to initialize libdc1394"
RUN ln /dev/null /dev/raw1394

# Install third party libraries for user function.
RUN pip install -U six
RUN pip install -U pip && pip install -U setuptools

RUN pip install \
    wand==0.4.4 \
    opencv-python==3.3.0.10 \
    matplotlib==2.0.2 \
    scrapy==1.4.0 \
    cbor==1.0.0 \
    aliyun-fc==0.6 \
    meinheld==0.6.1 \
    aliyun-fc2==2.1.0 \
    tablestore==4.6.0 \
    aliyun-python-sdk-core==2.9.5 \
    aliyun-python-sdk-iot==6.1.0 \
    aliyun-python-sdk-ecs==4.10.1 \
    aliyun-python-sdk-vpc==3.0.2 \
    aliyun-python-sdk-rds==2.1.4 \
    aliyun-python-sdk-kms==2.5.0 \
    aliyun-python-sdk-imm==1.3.4 \
    aliyun-log-python-sdk==0.6.38 \
    aliyun-python-sdk-ram==3.0.0 \
    aliyun-python-sdk-sts==3.0.0 \
    aliyun-mns==1.1.5 \
    aliyun-python-sdk-cdn==2.6.2 \
    pydatahub==2.11.2 \
    oss2==2.6.0

# Generate usernames
RUN for i in $(seq 10000 10999); do \
        echo "user$i:x:$i:$i::/tmp:/usr/sbin/nologin" >> /etc/passwd; \
    done

# Start a shell by default
CMD ["bash"]

ENV FC_FUNC_CODE_PATH=/code 
ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib