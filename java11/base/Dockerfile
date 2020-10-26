FROM maven:3.6.3-jdk-11

LABEL maintainer="alibaba-serverless-fc"

# Environment variables can be overwritten by running
# $ docker run --env <key>=<value>
ENV FC_SERVER_PATH=/var/fc/runtime/java11

ENV FC_RUNTIME_ROOT_PATH=${FC_SERVER_PATH}/bootstrap \
    FC_RUNTIME_SYSTEM_PATH=${FC_SERVER_PATH}

ENV FC_SERVER_PORT=9000 \
    FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log \
    FC_SERVER_LOG_LEVEL=debug \
    FC_FUNC_CODE_PATH=/code

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib

RUN mkdir -p ${FC_SERVER_LOG_PATH}
RUN chmod 777 ${FC_SERVER_LOG_PATH}
RUN chmod -R 777 /tmp/

ENV MAVEN_REPOSITORY=/cache/maven.repository

# Change work directory.
WORKDIR ${FC_FUNC_CODE_PATH}

# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak
# COPY commons/debian-buster-sources.list /etc/apt/sources.list

# Install common libraries
RUN apt-get update && apt-get install -y \
    make \
    imagemagick \
    libopencv-dev \
    fonts-wqy-zenhei \
    fonts-wqy-microhei

RUN ln -s /bin/bash /usr/bin/bash \
    && ln -s /bin/grep /usr/bin/grep

# Suppress opencv error: "libdc1394 error: Failed to initialize libdc1394"
RUN ln /dev/null /dev/raw1394

COPY java11/base/pom.xml .

# Generate usernames
RUN for i in $(seq 10000 10999); do \
    echo "user$i:x:$i:$i::/tmp:/usr/sbin/nologin" >> /etc/passwd; \
    done

RUN ["mvn", "clean", "install"]
RUN ["mvn", "dependency:go-offline"]
RUN rm -f pom.xml

RUN cp /usr/local/openjdk-11/bin/java /usr/bin/java