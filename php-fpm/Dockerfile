FROM php:7.2-fpm-stretch
LABEL Description="Esta imagen sirve para la configuración de php-fpm para moodle" Version="1.0"

ARG DOCUMENT_ROOT=/var/www/html
ARG MY_TZ=America/Costa_Rica

ENV WEB_DOCUMENT_ROOT=$DOCUMENT_ROOT
ENV WEB_MY_TZ=${MY_TZ}

# PHP
RUN apt-get update && \
    pecl install xdebug && \
    # https://docs.moodle.org/35/en/PHP \
    apt-get install -y --no-install-recommends libxml2-dev zlib1g-dev libpng-dev \
        libfreetype6-dev libjpeg62-turbo-dev libicu-dev libpspell-dev libpq-dev libldap2-dev libxslt-dev && \
    docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    docker-php-ext-configure xmlrpc --with-libxml-dir=/usr/include/ && \
    docker-php-ext-install xmlrpc && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
    docker-php-ext-install ldap && \
    # Ya están instalados curl iconv mbstring openssl tokenizer ctype simplexml spl pcre dom xml json  \
    docker-php-ext-install soap zip intl pspell pgsql xsl && \
    docker-php-ext-configure opcache --enable-opcache && docker-php-ext-install opcache

# tideways_xhprof
RUN tideways_latest="$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/tideways/php-xhprof-extension/releases/latest))" && \
    xhprof_url="https://github.com/tideways/php-xhprof-extension/archive/${tideways_latest}.tar.gz" && \
    mkdir -p /usr/src/php/ext/tideways_xhprof && \
    curl -L ${xhprof_url} | tar -xz --strip-components=1 -C /usr/src/php/ext/tideways_xhprof && \
    docker-php-ext-configure /usr/src/php/ext/tideways_xhprof && \
    docker-php-ext-install -j "$(nproc)" /usr/src/php/ext/tideways_xhprof

# Adicionales
RUN apt-get install -y graphviz zip unzip aspell-es

# Config
COPY php-fpm/conf/custom-php.ini /usr/local/etc/php/conf.d/php.ini
COPY php-fpm/conf/custom-xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY php-fpm/conf/custom-opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY php-fpm/conf/php-fpm-xdebug-entrypoint.sh /usr/local/bin/php-fpm-xdebug-entrypoint

# TZ
RUN echo "${WEB_MY_TZ}" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i  "s@MY_TZ_WILL_BE_REPLACE@${WEB_MY_TZ}@" /usr/local/etc/php/conf.d/xdebug.ini

# Limpieza
RUN apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    rm -r /var/cache/apt/*

# Propiedad
RUN usermod -u 1000 www-data

WORKDIR ${WEB_DOCUMENT_ROOT}

EXPOSE 9000

ENTRYPOINT ["php-fpm-xdebug-entrypoint"]

CMD ["php-fpm"]
