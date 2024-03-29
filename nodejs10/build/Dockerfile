ARG TAG="latest"
FROM aliyunfc/runtime-nodejs10:${TAG}

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

ARG FUN_VERSION
ARG FCLI_VERSION
ARG FUN_INSTALL_VERSION

RUN curl -o fcli.zip https://gosspublic.alicdn.com/fcli/fcli-${FCLI_VERSION}-linux-amd64.zip \
    && unzip -o fcli.zip -d /usr/local/bin/ \
    && rm fcli.zip

RUN curl -o fun.zip  https://gosspublic.alicdn.com/fun/fun-${FUN_VERSION}-linux.zip \
    && unzip -o fun.zip -d /usr/local/bin/ \
    && rm fun.zip \
    && mv /usr/local/bin/fun-v* /usr/local/bin/fun

RUN curl -o fun-install.zip https://gosspublic.alicdn.com/fun-install/fun-install-${FUN_INSTALL_VERSION}-linux-64.zip  \
    && unzip -o fun-install.zip -d /usr/local/bin/ \
    && rm fun-install.zip \
    && mv /usr/local/bin/fun-install-v* /usr/local/bin/fun-install \
    && ln -s /usr/local/bin/fun-install /usr/local/bin/s-install 

RUN mv /usr/bin/update-alternatives  /usr/bin/update-alternatives-origin \
    && ((test -f /usr/bin/pycompile && mv /usr/bin/pycompile  /usr/bin/pycompile-origin) || true)

COPY commons/update-alternatives  /usr/bin/
COPY commons/pycompile  /usr/bin/

RUN npm config set registry https://registry.npmmirror.com

RUN npm install -g yarn

WORKDIR /code

CMD ["npm", "rebuild"]
