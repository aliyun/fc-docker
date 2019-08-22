FROM python:3.7.4-slim-stretch

MAINTAINER alibaba-serverless-fc

RUN echo "deb http://deb.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list \
    && echo "deb-src http://deb.debian.org/debian/ stretch main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list \
    && echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
        curl \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh && bash nodesource_setup.sh
RUN apt install -y nodejs --no-install-recommends && rm -rf nodesource_setup.sh
RUN npm cache clean --force

# https://github.com/puckel/docker-airflow/issues/182
RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get install -y \
        openjdk-8-jdk=8u222-b10-1~deb9u1 \
        build-essential=12.3 \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

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
