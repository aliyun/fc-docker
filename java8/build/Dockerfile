FROM aliyunfc/runtime-java8:base-1.5.6
ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update \
    && apt-get install -y apt-utils \
        dialog \
        vim \ 
        cmake \
        zip \
        clang \
        build-essential \
        libgmp3-dev \
        python2.7-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s https://gosspublic.alicdn.com/fcli/fcli-v1.0.2-linux-amd64.zip > fcli.zip \
    && unzip -o fcli.zip -d /usr/local/bin/ \
    && rm fcli.zip

RUN curl -s https://gosspublic.alicdn.com/fun/fun-v2.16.1-linux-x64.zip > fun.zip \
    && unzip -o fun.zip -d /usr/local/bin/ \
    && rm fun.zip \
    && mv /usr/local/bin/fun-v* /usr/local/bin/fun

RUN mv /usr/bin/update-alternatives  /usr/bin/update-alternatives-origin \
 && mv /usr/bin/pycompile  /usr/bin/pycompile-origin

COPY commons/update-alternatives  /usr/bin/ 

COPY commons/pycompile  /usr/bin/

WORKDIR /code
