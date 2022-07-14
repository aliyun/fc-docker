FROM aliyunfc/fc-runtime:stretch-base

ENV NODE_VERSION v10.24.1
RUN wget http://mirrors.nju.edu.cn/nodejs/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.gz -O /tmp/node-${NODE_VERSION}-linux-x64.tar.gz \
    && cd /tmp && tar -zxvf /tmp/node-${NODE_VERSION}-linux-x64.tar.gz \
    && cp /tmp/node-${NODE_VERSION}-linux-x64/bin/node /usr/local/bin/ \
    && cp -r /tmp/node-${NODE_VERSION}-linux-x64/lib/node_modules /usr/local/lib/node_modules \
    && cp -r /tmp/node-${NODE_VERSION}-linux-x64/include/node /usr/local/include/node \
    && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && rm -rf /tmp/node-${NODE_VERSION}-linux-x64*

# Environment variables.
ENV FC_SERVER_PATH=/var/fc/runtime/nodejs10
ENV FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log
ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib
ENV PATH=${FC_SERVER_PATH}/node_modules/.bin:${PATH}
ENV NODE_PATH=/usr/local/lib/node_modules:/opt/nodejs/node10/node_modules:/opt/nodejs/node_modules

# Create directory.
RUN mkdir -p ${FC_SERVER_PATH}

# Create directories.
RUN mkdir -p \
    ${FC_SERVER_LOG_PATH}

RUN chmod 777 ${FC_SERVER_LOG_PATH}
RUN chmod -R 777 /tmp/

# Change work directory.
WORKDIR ${FC_SERVER_PATH}

# Expose the port number.
EXPOSE ${FC_SERVER_PORT}

RUN npm install --global --unsafe-perm \
    --registry http://registry.npmmirror.com \
    node-pre-gyp

# Install thrid party libraries for user function.
RUN npm install --global --unsafe-perm \
    --registry http://registry.npmmirror.com \
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
    @alicloud/pop-core@1.7.0 \
    @alicloud/fnf-2019-03-15@1.1.0

RUN npm cache clean --force

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# Start a shell by default
CMD ["bash"]