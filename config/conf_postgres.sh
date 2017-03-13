#!/bin/bash -e

if [ -e "/opt/db_dumps/dump-init.sql.gz" ]; then
    gunzip -c "/opt/db_dumps/dump-init.sql.gz" | psql -v ON_ERROR_STOP=1 -U ${POSTGRES_USER} ${POSTGRES_DB}
fi
