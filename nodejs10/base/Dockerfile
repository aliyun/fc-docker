FROM node:10.15.3-jessie

MAINTAINER alibaba-serverless-fc

# Environment variables.
ENV FC_SERVER_PATH=/var/fc/runtime/nodejs10 \
    NODE_PATH=/usr/local/lib/node_modules \
    PATH=${FC_SERVER_PATH}/node_modules/.bin:${PATH}
    
# Create directory.
RUN mkdir -p ${FC_SERVER_PATH}

ARG FC_RUNTIME_PATH=/var/fc/runtime

# Environment variables can be overwritten by running
# $ docker run --env <key>=<value>
ENV FC_SERVER_PORT=9000 \
    FC_SERVER_CAM_PORT=10080 \
    FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log \
    FC_SERVER_LOG_LEVEL=info \
    FC_FUNC_CODE_PATH=/code/ \
    FC_FUNC_LOG_PATH=/var/log/fc/

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib

# Create directories.
RUN mkdir -p \
    ${FC_SERVER_LOG_PATH}

RUN chmod 777 ${FC_SERVER_LOG_PATH}
RUN chmod -R 777 /tmp/

# Change work directory.
WORKDIR ${FC_SERVER_PATH}

# Expose the port number.
EXPOSE ${FC_SERVER_PORT}

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
COPY commons/debian-jessie-sources.list /etc/apt/sources.list

# Install common libraries
RUN apt-get update && apt-get --no-install-recommends  install -y apt-utils ca-certificates \
        cmake \
        imagemagick=8:6.8.9.9-5+deb8u15 \
        libopencv-dev=2.4.9.1+dfsg-1+deb8u2 \
        fonts-wqy-zenhei=0.9.45-6 \
        fonts-wqy-microhei=0.2.0-beta-2 \
    && rm -rf /var/lib/apt/lists/*

# Suppress opencv error: "libdc1394 error: Failed to initialize libdc1394"
RUN ln /dev/null /dev/raw1394

# Install thrid party libraries for user function.
RUN npm install --global --unsafe-perm \
        --registry http://registry.npm.taobao.org \
        co@4.6.0 \
        gm@1.23.0 \
        ali-oss@4.10.1 \
        aliyun-sdk@1.11.10 \
        @alicloud/fc@1.2.2 \
        tablestore@4.2.0\
        @alicloud/fc2@2.1.0 \
        opencv@6.2.0 \
        body@5.1.0 \
        raw-body@2.3.2 \
        ali-mns@2.6.5 \
        @alicloud/pop-core@1.7.0

RUN npm cache clean --force

# Generate usernames
RUN for i in $(seq 10000 10999); do \
        echo "user$i:x:$i:$i::/tmp:/usr/sbin/nologin" >> /etc/passwd; \
    done

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Start a shell by default
CMD ["bash"]