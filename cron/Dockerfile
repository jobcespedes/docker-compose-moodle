FROM metics/php-fpm:5.6
LABEL Description="Esta imagen sirve para la configuración del cron de moodle" Version="1.0"

ARG DOCUMENT_ROOT=/var/www/html
ARG POSTGRES_DB=moodle
ARG POSTGRES_USER=metics
ARG POSTGRES_PASSWORD=devpass
ARG MOODLE_DATA=/var/moodledata
ARG WWWROOT=localhost

ENV WEB_DOCUMENT_ROOT=$DOCUMENT_ROOT
ENV DB_POSTGRES_DB=$POSTGRES_DB
ENV DB_POSTGRES_USER=$POSTGRES_USER
ENV DB_POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ENV WEB_MOODLE_DATA=$MOODLE_DATA
ENV WEB_WWWROOT=$WWWROOT

RUN apt-get update && apt-get install --no-install-recommends -y cron inetutils-syslogd supervisor

# Archivos cron
ADD ./config/moodle.cron /etc/cron.d/moodle
ADD ./config/supervisor_cron.conf /etc/supervisor/conf.d/supervisor_cron.conf

RUN sed -i "s@DOCROOT@${WEB_DOCUMENT_ROOT}@" /etc/cron.d/moodle && \
    chmod 0644 /etc/cron.d/moodle && \
    touch /var/log/cron.log && \
    touch /etc/crontab /etc/cron.*/* && \
    sed -i "s@^#cron.@cron.@" /etc/syslog.conf

# Limpieza
RUN apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    rm -r /var/cache/apt/*

# Correr el archivo
COPY ./config/conf_moodle.sh /opt/conf_moodle.sh

CMD /opt/conf_moodle.sh && /usr/bin/supervisord
