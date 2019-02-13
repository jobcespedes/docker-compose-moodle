FROM webdevops/apache:debian-9
LABEL Description="Esta imagen sirve para la configuración de apache para moodle" Version="1.0"

ARG PHP_SOCKET=php-fpm:9000
ARG DOCUMENT_ROOT=/var/www/html
ARG ALIAS_DOMAIN=*.vm
ARG MY_TZ=America/Costa_Rica

ENV WEB_PHP_SOCKET=$PHP_SOCKET
ENV WEB_DOCUMENT_ROOT=$DOCUMENT_ROOT
ENV WEB_ALIAS_DOMAIN=$ALIAS_DOMAIN
ENV WEB_MY_TZ=${MY_TZ}

# Config
RUN rm -rf /etc/apache2/mods-enabled/* && \
    # Webdevops \
    a2enmod actions proxy proxy_fcgi mpm_event ssl && \
    # Moodle \
    a2enmod actions alias authz_host autoindex cache cgid deflate dir expires headers mime rewrite

# TZ
RUN echo "${WEB_MY_TZ}" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

WORKDIR $WEB_DOCUMENT_ROOT

EXPOSE 80

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]

CMD ["supervisord"]
