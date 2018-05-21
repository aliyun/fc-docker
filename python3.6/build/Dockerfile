FROM python:3.6

MAINTAINER alibaba-serverless-fc

# Server path.
ENV FC_SERVER_PATH=/var/fc/runtime/python3

# Create directory.
RUN mkdir -p ${FC_SERVER_PATH}
RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak

ENV FC_FUNC_CODE_PATH=/code/

COPY pip.conf /etc/pip.conf
COPY sources.list /etc/apt/

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Install dev dependencies.
RUN pip install coverage

# Install common libraries
RUN apt-get update && apt-get install -y \
        imagemagick=8:6.8.9.9-5+deb8u11 \
        libopencv-dev=2.4.9.1+dfsg-1+deb8u1 \
        fonts-wqy-zenhei=0.9.45-6 \
        fonts-wqy-microhei=0.2.0-beta-2

# Suppress opencv error: "libdc1394 error: Failed to initialize libdc1394"
RUN ln /dev/null /dev/raw1394

# Install third party libraries for user function.
# aliyun-log-python-sdk and tablestore protobuf version has conflict, don't change their installation sequence
RUN pip install \
    oss2==2.3.3 \
    wand==0.4.4 \
    opencv-python==3.3.0.10 \
    numpy==1.13.1 \
    scipy==0.19.1 \
    matplotlib==2.0.2 \
    scrapy==1.4.0 \
    cbor==1.0.0 \
    aliyun-fc==0.6 \
    aliyun-log-python-sdk==0.6.14 \
    tablestore==4.3.2 \
    aliyun-fc2==2.0.2

# Generate usernames
RUN for i in $(seq 10000 10999); do \
        echo "user$i:x:$i:$i::/tmp:/usr/sbin/nologin" >> /etc/passwd; \
    done

# Start a shell by default
CMD ["bash"]

ENV FC_FUNC_CODE_PATH=/code 
ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib