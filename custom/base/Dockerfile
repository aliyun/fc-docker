FROM python:3.7.4-slim-stretch

LABEL maintainer="alibaba-serverless-fc"

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
RUN apt-get update && apt-get install -y \
    fonts-wqy-zenhei=0.9.45-6 \
    fonts-wqy-microhei=0.2.0-beta-2 \
    xfonts-wqy=1.0.0~rc1-6 \
    libprocps6=2:3.3.12-3+deb9u1 \
    procps=2:3.3.12-3+deb9u1 \
    net-tools=1.60+git20161116.90da8a0-1 \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

# https://github.com/puckel/docker-airflow/issues/182
RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk=8u272-b10-0+deb9u1 \
    build-essential=12.3 \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

RUN cd /usr/local/bin && wget http://www-eu.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
RUN cd /usr/local/bin && tar xzf apache-maven-3.6.3-bin.tar.gz && ln -s apache-maven-3.6.3 apache-maven && rm apache-maven-3.6.3-bin.tar.gz
ENV M2_HOME=/usr/local/bin/apache-maven
ENV PATH=${M2_HOME}/bin:${PATH}

# https://www.cloudbooklet.com/install-php-7-4-on-debian-10/
RUN apt-get update && apt-get install -y gnupg2 ca-certificates lsb-release apt-transport-https --no-install-recommends && rm -r /var/lib/apt/lists/*
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list
RUN apt-get update && apt-get install -y pkg-config zlib1g-dev libmemcached-dev libmcrypt-dev --no-install-recommends && rm -r /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
    php7.4 \
    php7.4-common \
    php7.4-cli \
    php7.4-mysql \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-curl \
    php7.4-gd \
    php7.4-imagick \
    php7.4-dev \
    php7.4-imap \
    php7.4-mbstring \
    php7.4-opcache \
    php7.4-soap \
    php7.4-zip \
    php7.4-intl \
    php7.4-bcmath \
    php7.4-sqlite3 \
    php7.4-pgsql \
    php-pear \
    autoconf \
    automake \
    libtool \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

# install swoole extension and enable it
RUN pecl install swoole
RUN echo "extension=swoole.so" >> /etc/php/7.4/cli/conf.d/20-swoole.ini

# http://php.net/manual/en/info.configuration.php#ini.enable-dl
RUN sed -i 's/enable_dl = Off/enable_dl = On/'  /etc/php/7.4/cli/php.ini

RUN /bin/sh -c 'curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer'

# install some extension but  disable decault, user can use dl function to load extension dynamically
RUN pecl channel-update pecl.php.net \
    && pecl install redis-5.1.1 \
    && pecl install protobuf-3.11.2 \
    && pecl install memcached-3.1.5 \
    && pecl install mcrypt-1.0.3

# Install ruby2.7, https://www.ruby-lang.org/zh_cn/documentation/installation/
RUN wget https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.0.tar.gz && \
    tar -zxvf ruby-2.7.0.tar.gz && \
    cd ./ruby-2.7.0 && \
    ./configure --prefix=/usr/local/ruby && \
    make && make install && \
    cd ../ && rm -rf ruby-2.7.0 && rm ruby-2.7.0.tar.gz

ENV PATH=$PATH:/usr/local/ruby/bin

# support rails, https://edgeguides.rubyonrails.org/getting_started.html
RUN apt-get update && apt-get install -y \
    sqlite3=3.16.2-5+deb9u1 \
    libsqlite3-dev=3.16.2-5+deb9u1 \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

# support typescript
RUN npm install --global --unsafe-perm \
    --registry http://registry.npm.taobao.org \
    typescript@3.8.3 \
    yarn@1.22.4

RUN npm cache clean --force

# Remove package.json
RUN rm -f package.json

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
