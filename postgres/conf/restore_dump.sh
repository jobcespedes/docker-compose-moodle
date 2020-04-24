#!/bin/bash -e

if [ -e "/opt/db_dumps/dump-init.dump" ]; then
    pg_restore -U ${POSTGRES_USER} -d postgres -c -C -O --role ${POSTGRES_USER} /opt/db_dumps/dump-init.dump
fi
