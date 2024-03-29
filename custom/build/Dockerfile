ARG TAG="latest"
FROM aliyunfc/runtime-custom:${TAG}
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /mnt/auto

RUN apt-get update \
    && apt-get --no-install-recommends  install -y apt-utils ca-certificates \
    dialog \
    clang \
    build-essential \
    libgmp3-dev \
    sudo \
    libffi-dev \
    zlibc \
    zlib1g \
    zlib1g-dev \
    libssl-dev \
    libreadline-dev \
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

# custom maven speedup
COPY custom/build/pom.xml .
COPY custom/build/settings.xml /usr/share/maven/conf/settings.xml
RUN ["mvn", "dependency:go-offline"]
RUN rm -f pom.xml

RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
RUN npm config set registry https://registry.npmmirror.com
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
RUN pip install --upgrade pip

WORKDIR /code
