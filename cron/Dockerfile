ARG ARG_CRON_IMAGE_FROM=moodledev/php
FROM ${ARG_CRON_IMAGE_FROM}

LABEL Description="Esta imagen sirve para la configuración del cron de moodle" Version="1.0"

ARG DOCUMENT_ROOT=/var/www/html

ENV WEB_DOCUMENT_ROOT=$DOCUMENT_ROOT

USER 0

RUN apt-get update && \
    apt-get install --no-install-recommends -y cron && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/* && \
    rm -r /var/cache/apt/*

COPY --chown=${CTR_USER_ID}:0 conf/container-entrypoint.d/cron-entrypoint /opt/container-entrypoint.d/cron-entrypoint

RUN echo "*/1 * * * * $(getent passwd "$CTR_USER_ID" | cut -d: -f1) /usr/local/bin/php  ${WEB_DOCUMENT_ROOT}/admin/cli/cron.php 1>/proc/1/fd/1 2>/proc/1/fd/2" >> /etc/crontab && \
    chmod u+s /usr/sbin/cron

USER ${CTR_USER_ID}

CMD ["/opt/container-entrypoint.d/cron-entrypoint"]
