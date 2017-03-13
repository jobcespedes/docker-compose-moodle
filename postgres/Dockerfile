FROM postgres:9.3
LABEL Description="Esta imagen sirve para la configuración de la capa de base de datos" Version="1.0"

ARG locale=es_CR
ENV LANG ${locale}.utf8

# Locale
RUN localedef -i ${locale} -c -f UTF-8 -A /usr/share/locale/locale.alias ${locale}.UTF-8

# TZ
RUN echo "America/Costa_Rica" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

COPY config/conf_postgres.sh /docker-entrypoint-initdb.d/conf_postgres.sh
