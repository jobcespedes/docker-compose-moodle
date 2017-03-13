#!/bin/bash -e

# Moodle
cp -p ${WEB_DOCUMENT_ROOT}/config-dist.php ${WEB_DOCUMENT_ROOT}/config.php
sed -i \
    -e  "s@^\$CFG->dbhost.*@\$CFG->dbhost    = 'postgres';@" \
    -e  "s@^\$CFG->dbname.*@\$CFG->dbname    = '${DB_POSTGRES_DB}';@" \
    -e  "s@^\$CFG->dbuser.*@\$CFG->dbuser    = '${DB_POSTGRES_USER}';@" \
    -e  "s@^\$CFG->dbpass.*@\$CFG->dbpass    = '${DB_POSTGRES_PASSWORD}';@" \
    -e  "s@^\$CFG->wwwroot.*@\$CFG->wwwroot    = 'http://${WEB_WWWROOT}';@" \
    -e  "s@^\$CFG->dataroot.*@\$CFG->dataroot    = '${WEB_MOODLE_DATA}';@" \
    ${WEB_DOCUMENT_ROOT}/config.php
