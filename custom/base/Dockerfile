FROM aliyunfc/fc-runtime:java8-stretch-base

# Install python3.7 and Make python 3.7 the default
ENV LANG C.UTF-8
# extra dependencies (over what buildpack-deps already includes)
RUN apt-get update && apt-get install -y --no-install-recommends \
		libbluetooth-dev \
		tk-dev \
		uuid-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
       gnupg \
       dirmngr \
       gcc \
	&& rm -rf /var/lib/apt/lists/*

ENV GPG_KEY 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
ENV PYTHON_VERSION 3.7.4

RUN set -ex \
	\
	&& wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" \
	&& wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY" \
	&& gpg --batch --verify python.tar.xz.asc python.tar.xz \
	&& { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
	&& rm -rf "$GNUPGHOME" python.tar.xz.asc \
	&& mkdir -p /usr/src/python \
	&& tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
	&& rm python.tar.xz \
	\
	&& cd /usr/src/python \
	&& gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& ./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-system-expat \
		--with-system-ffi \
		--without-ensurepip \
	&& make -j "$(nproc)" \
# setting PROFILE_TASK makes "--enable-optimizations" reasonable: https://bugs.python.org/issue36044 / https://github.com/docker-library/python/issues/160#issuecomment-509426916
		PROFILE_TASK='-m test.regrtest --pgo \
			test_array \
			test_base64 \
			test_binascii \
			test_binhex \
			test_binop \
			test_bytes \
			test_c_locale_coercion \
			test_class \
			test_cmath \
			test_codecs \
			test_compile \
			test_complex \
			test_csv \
			test_decimal \
			test_dict \
			test_float \
			test_fstring \
			test_hashlib \
			test_io \
			test_iter \
			test_json \
			test_long \
			test_math \
			test_memoryview \
			test_pickle \
			test_re \
			test_set \
			test_slice \
			test_struct \
			test_threading \
			test_time \
			test_traceback \
			test_unicode \
		' \
	&& make install \
	&& rm -rf /usr/src/python \
	\
	&& find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) \) \
			-o \( -type f -a -name 'wininst-*.exe' \) \
		\) -exec rm -rf '{}' + \
	\
	&& ldconfig \
	\
	&& python3 --version

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& ln -s idle3 idle \
	&& ln -s pydoc3 pydoc \
	&& ln -s python3 python \
	&& ln -s python3-config python-config

# https://github.com/pypa/get-pip
ENV PYTHON_GET_PIP_URL https://bootstrap.pypa.io/get-pip.py

RUN set -ex; \
	\
	wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
	\
	python get-pip.py \
	; \
	pip --version; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' +; \
	rm -f get-pip.py

# Install nodejs10
RUN wget http://mirrors.nju.edu.cn/nodejs/v10.16.2/node-v10.16.2-linux-x64.tar.gz -O /tmp/node-v10.16.2-linux-x64.tar.gz \
    && cd /tmp && tar -zxvf /tmp/node-v10.16.2-linux-x64.tar.gz \
    && cp /tmp/node-v10.16.2-linux-x64/bin/node /usr/bin/ \
    && cp -r /tmp/node-v10.16.2-linux-x64/lib/node_modules /usr/lib/node_modules \
    && cp -r /tmp/node-v10.16.2-linux-x64/include/node /usr/include/node \
    && ln -s /usr/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm \
    && ln -s /usr/lib/node_modules/npm/bin/npx-cli.js /usr/bin/npx \
    && rm -rf /tmp/node-v10.16.2-linux-x64*

RUN apt-get update && apt-get install -y \
    unzip \
    xfonts-wqy \
    libprocps6 \
    procps \
    net-tools \
    nginx \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

# Install php7.4
# https://www.cloudbooklet.com/install-php-7-4-on-debian-10/
RUN apt-get update && apt-get install -y gnupg2 ca-certificates lsb-release apt-transport-https --no-install-recommends && rm -r /var/lib/apt/lists/*
RUN wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list
RUN apt-get update && apt-get install -y pkg-config zlib1g-dev libmemcached-dev libmcrypt-dev --no-install-recommends && rm -r /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y \
        php7.4 \
        php7.4-common \
        php7.4-fpm \
        php7.4-cli \
        php7.4-cgi \
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
        php7.4-json \
        php7.4-bcmath \
        php7.4-sqlite3 \
        php7.4-pgsql \
        php7.4-readline \
        php-pear \
        autoconf \
        automake \
        libtool \
        libedit2 \
        libncurses5 \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

# install swoole extension and enable it, the previous built-in version is 4.5.2
# https://aone.alibaba-inc.com/req/31344463
RUN curl -o /tmp/swoole.tar.gz https://github.com/swoole/swoole-src/archive/v4.5.2.tar.gz -L && \
    tar zxvf /tmp/swoole.tar.gz && cd swoole-src* && \
    phpize && \
    ./configure \
    --enable-sockets \
    --enable-openssl  \
    --enable-http2  \
    --enable-mysqlnd && \
    make && make install && \
    rm -rf swoole*
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

RUN echo "extension=redis.so" >> /etc/php/7.4/cli/conf.d/20-redis.ini && \
    echo "extension=protobuf.so" >> /etc/php/7.4/cli/conf.d/20-protobuf.ini && \
    echo "extension=memcached.so" >> /etc/php/7.4/cli/conf.d/20-memcached.ini && \
    echo "extension=mcrypt.so" >> /etc/php/7.4/cli/conf.d/20-mcrypt.ini

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
        sqlite3 \
        libsqlite3-dev \
    --no-install-recommends && rm -r /var/lib/apt/lists/*

# support typescript
RUN npm install --global --unsafe-perm \
        --registry http://registry.npm.taobao.org \
        typescript@3.8.3 \
        yarn@1.22.4

RUN npm cache clean --force

# Remove package.json
RUN rm -f package.json

# Import the public repository GPG keys
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# Register the Microsoft Product feed
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list'
# Install powershell
RUN apt-get update && apt-get install -y powershell=7.1.0-1.debian.9 --no-install-recommends && rm -r /var/lib/apt/lists/*


ENV FC_SERVER_PORT=9000 \
    FC_FUNC_CODE_PATH=/code

ENV PYTHONPATH=/code

ENV BOOTSTRAP_FILE=bootstrap

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib

WORKDIR ${FC_FUNC_CODE_PATH}

# Start a shell by default
CMD ["bash"]