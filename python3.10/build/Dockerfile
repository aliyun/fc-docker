ARG TAG="latest"
FROM aliyunfc/runtime-python3.10:${TAG}

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /mnt/auto
RUN apt-get update \
    && apt-get --no-install-recommends  install -y apt-utils ca-certificates \    
    dialog \
    vim \
    cmake \
    zip \
    unzip \
    clang \
    build-essential \
    libgmp3-dev \
    python2.7-dev \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN echo "ALL ALL=NOPASSWD: ALL" >> /etc/sudoers

ARG FUN_INSTALL_VERSION
RUN curl -o fun-install.zip https://gosspublic.alicdn.com/fun-install/fun-install-${FUN_INSTALL_VERSION}-linux-64.zip  \
    && unzip -o fun-install.zip -d /usr/local/bin/ \
    && rm fun-install.zip \
    && mv /usr/local/bin/fun-install-v* /usr/local/bin/fun-install \
    && ln -s /usr/local/bin/fun-install /usr/local/bin/s-install 

RUN mv /usr/bin/update-alternatives  /usr/bin/update-alternatives-origin \
    && ((test -f /usr/bin/pycompile && mv /usr/bin/pycompile  /usr/bin/pycompile-origin) || true)

COPY commons/update-alternatives  /usr/bin/ 

COPY commons/pycompile  /usr/bin/

RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

WORKDIR /code