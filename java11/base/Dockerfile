FROM aliyunfc/fc-runtime:stretch-base

RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get install -y \
        openjdk-11-jdk \
        maven \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

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

RUN ln -s /bin/bash /usr/bin/bash \
    && ln -s /bin/grep /usr/bin/grep

COPY java11/base/pom.xml .

RUN mv /usr/share/maven/conf/settings.xml /usr/share/maven/conf/settings.xml.bk
COPY java11/base/settings.xml /usr/share/maven/conf/settings.xml

RUN ["mvn", "clean", "install"]
RUN ["mvn", "dependency:go-offline"]
RUN rm -f pom.xml