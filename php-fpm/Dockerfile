FROM php:5-fpm
LABEL Description="Esta imagen sirve para la configuración de php-fpm para moodle" Version="1.0"

ARG DOCUMENT_ROOT=/var/www/html

ENV WEB_DOCUMENT_ROOT=$DOCUMENT_ROOT

# PHP
RUN apt-get update && \
    # Bug https://github.com/docker-library/php/issues/133 \
    apt-get install -y --no-install-recommends php5-xdebug && \
    # https://docs.moodle.org/31/en/PHP \
    apt-get install -y --no-install-recommends libxml2-dev zlib1g-dev libpng12-dev \
        libfreetype6-dev libjpeg62-turbo-dev libicu-dev libpspell-dev libpq-dev libldap2-dev && \
    docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    docker-php-ext-configure xmlrpc --with-libxml-dir=/usr/include/ && \
    docker-php-ext-install xmlrpc && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
    docker-php-ext-install ldap && \
    # Ya están instalados curl iconv mbstring openssl tokenizer ctype simplexml spl pcre dom xml json  \
    docker-php-ext-install soap zip intl pspell pgsql && \
    docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install opcache

# Adicionales
RUN apt-get install -y graphviz clamav clamav-daemon zip unzip aspell-es

# Config
COPY config/conf_php.ini /usr/local/etc/php/conf.d/php.ini
COPY config/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY config/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# TZ
RUN echo "America/Costa_Rica" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# Limpieza
RUN apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    rm -r /var/cache/apt/*

# Propiedad
RUN usermod -u 1000 www-data

WORKDIR ${WEB_DOCUMENT_ROOT}

CMD ["php-fpm"]

EXPOSE 9000
