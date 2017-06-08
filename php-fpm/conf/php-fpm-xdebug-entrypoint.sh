#!/bin/bash -e

if [ $WWW_PORT = '80' ]; then
    host_port="${WWWROOT}"
else
    host_port="${WWWROOT}:${WWW_PORT}"
fi

# Moodle
cp -p ${DOCUMENT_ROOT}/config-dist.php ${DOCUMENT_ROOT}/config.php
sed -i \
    -e  "s@^\$CFG->dbhost.*@\$CFG->dbhost    = 'postgres';@" \
    -e  "s@^\$CFG->dbname.*@\$CFG->dbname    = '${POSTGRES_DB}';@" \
    -e  "s@^\$CFG->dbuser.*@\$CFG->dbuser    = '${POSTGRES_USER}';@" \
    -e  "s@^\$CFG->dbpass.*@\$CFG->dbpass    = '${POSTGRES_PASSWORD}';@" \
    -e  "s@^\$CFG->wwwroot.*@\$CFG->wwwroot    = 'http://${host_port}';@" \
    -e  "s@^\$CFG->dataroot.*@\$CFG->dataroot    = '${MOODLE_DATA}';@" \
    ${DOCUMENT_ROOT}/config.php

# Remote xdebug host
sed -i "s@dockerhost@$(/sbin/ip route|awk '/default/ { print $3 }')@" /usr/local/etc/php/conf.d/xdebug.ini

docker-php-entrypoint "$@"
