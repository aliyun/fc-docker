FROM aliyunfc/fc-runtime:php7.2-stretch-base

# Server path.
ENV FC_SERVER_PATH=/var/fc/runtime/php7.2
# php package path.
ENV FC_PHP_LIB_PATH=${FC_SERVER_PATH}/builtIn
# Create directory.
RUN mkdir -p ${FC_PHP_LIB_PATH}

ENV FC_SERVER_LOG_PATH=${FC_SERVER_PATH}/var/log
# Create directories.
RUN mkdir -p ${FC_SERVER_LOG_PATH}

ENV LD_LIBRARY_PATH=${FC_FUNC_CODE_PATH}:${FC_FUNC_CODE_PATH}/lib:/usr/local/lib
ENV PHP_INI_SCAN_DIR=${FC_FUNC_CODE_PATH}extension:/usr/local/etc/php/conf.d

# Change work directory.
WORKDIR ${FC_SERVER_PATH}

# Change work directory.
WORKDIR ${FC_PHP_LIB_PATH}

# Install third party libraries for user function.
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
COPY php7.2/base/composer.json ./
COPY php7.2/base/composer.lock ./
RUN composer install

RUN echo "memory_limit=3072M" >> /usr/local/etc/php/php.ini
RUN echo "enable_post_data_reading=1" >> /usr/local/etc/php/php.ini

# Change work directory.
WORKDIR ${FC_SERVER_PATH}