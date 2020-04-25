FROM python:3.7.4-slim-stretch

MAINTAINER alibaba-serverless-fc

COPY commons/debian-jessie-sources.list /etc/apt/sources.list

RUN echo "deb http://deb.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list \
    && echo "deb-src http://deb.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update && apt-get --no-install-recommends install -y \
        curl \
        wget \
        unzip \
    && rm -r /var/lib/apt/lists/*

RUN wget https://nodejs.org/download/release/v10.16.2/node-v10.16.2-linux-x64.tar.gz -O /tmp/node-v10.16.2-linux-x64.tar.gz \
    && cd /tmp && tar -zxvf /tmp/node-v10.16.2-linux-x64.tar.gz \
    && cp /tmp/node-v10.16.2-linux-x64/bin/node /usr/bin/ \
    && cp -r /tmp/node-v10.16.2-linux-x64/lib/node_modules /usr/lib/node_modules \
    && cp -r /tmp/node-v10.16.2-linux-x64/include/node /usr/include/node \
    && ln -s /usr/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm \
    && ln -s /usr/lib/node_modules/npm/bin/npx-cli.js /usr/bin/npx \
    && rm -rf /tmp/node-v10.16.2-linux-x64*

# https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-debian-9
RUN apt-get update && apt-get --no-install-recommends  install -y apt-utils ca-certificates \
        fonts-wqy-zenhei=0.9.45-6 \
        fonts-wqy-microhei=0.2.0-beta-2 \
        xfonts-wqy=1.0.0~rc1-6 \
    && rm -r /var/lib/apt/lists/*

# https://github.com/puckel/docker-airflow/issues/182
RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get --no-install-recommends  install -y apt-utils ca-certificates \
        openjdk-8-jdk \
        build-essential=12.3 \
    && rm -r /var/lib/apt/lists/*


# Generate usernames
RUN for i in $(seq 10000 10999); do \
        echo "user$i:x:$i:$i::/tmp:/usr/sbin/nologin" >> /etc/passwd; \
    done

ENV FC_SERVER_PORT=9000 \
   FC_FUNC_CODE_PATH=/code

ENV PYTHONPATH=/code

ENV BOOTSTRAP_FILE=bootstrap

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

WORKDIR ${FC_FUNC_CODE_PATH}
