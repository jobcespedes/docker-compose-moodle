#!/bin/bash -e

if [[ $WWW_PORT == '80' ]]; then
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
gateway=$(awk 'END{print $1}' /etc/hosts |  awk -F "." '{print $1 "." $2 "." $3 "." 1}')
sed -i "s@dockerhost@${gateway}@" /usr/local/etc/php/conf.d/xdebug.ini

# Custom CA
if ! [ -z ${CA_CERT+x} ]; then
    # On Debian, place the CA certificate where 'update-ca-certificates' will find it
    cat << _EOF > /usr/local/share/ca-certificates/custom-ca.crt
${CA_CERT}
_EOF
    update-ca-certificates
    if [ -f /usr/local/lib/python2.7/dist-packages/certifi/cacert.pem ]; then
        rm /usr/local/lib/python2.7/dist-packages/certifi/cacert.pem
        ln -s /usr/local/share/ca-certificates/custom-ca.crt /usr/local/lib/python2.7/dist-packages/certifi/cacert.pem
    fi
fi

docker-php-entrypoint "$@"
