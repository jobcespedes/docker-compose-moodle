#!/bin/bash -e

check_database_installed() {
    # check database is installed
    # code exit 2 means database scheme not installed
    set -e
    export MOODLE_APP=${DOCUMENT_ROOT}
    php <<'CODE'
<?php
define('CLI_SCRIPT', true);
define('NO_UPGRADE_CHECK', true);
define('CACHE_DISABLE_ALL', true); // This prevents reading of existing caches.
$MOODLE_APP = getenv('MOODLE_APP') ?: '/var/www/html';
require($MOODLE_APP . '/config.php');
if (!empty($CFG->upgraderunning)) {
    echo "CHECK: Upgrade is running\n";
    exit(0);
}
if (empty($CFG->version)) {
    echo "CHECK: Database is not yet installed\n";
    exit(2);
}
?>
CODE
}

# Moodle
if [ "$MOODLE_INSTALL_UNATTENDED" == "true" ]; then
  echo "Unattended installation"
  if [[ $WWW_PORT == '80' ]]; then
      host_port="${WWWROOT}"
  else
      host_port="${WWWROOT}:${WWW_PORT}"
  fi

  cp -p ${DOCUMENT_ROOT}/config-dist.php ${DOCUMENT_ROOT}/config.php
  sed -i \
      -e  "s@^\$CFG->dbhost.*@\$CFG->dbhost    = 'postgres';@" \
      -e  "s@^\$CFG->dbname.*@\$CFG->dbname    = '${POSTGRES_DB}';@" \
      -e  "s@^\$CFG->dbuser.*@\$CFG->dbuser    = '${POSTGRES_USER}';@" \
      -e  "s@^\$CFG->dbpass.*@\$CFG->dbpass    = '${POSTGRES_PASSWORD}';@" \
      -e  "s@^\$CFG->wwwroot.*@\$CFG->wwwroot    = 'http://${host_port}';@" \
      -e  "s@^\$CFG->dataroot.*@\$CFG->dataroot    = '${MOODLE_DATA}';@" \
      ${DOCUMENT_ROOT}/config.php


  install_check_exit_code=$(check_database_installed &>/dev/null || echo $?)
  echo "Install check exit code: $install_check_exit_code"
  if [ -n "$install_check_exit_code" ] && [ "$install_check_exit_code" != "0" ] && [ "$install_check_exit_code" != "2" ]; then
    retries=10
    until [ "$retries" -le 0 ] || [ -z "$install_check_exit_code" ] || [ "$install_check_exit_code" == "0" ] || [ "$install_check_exit_code" == "2" ]; do
      echo "Waiting for database to be ready: $retries retries left"
      sleep 2
      install_check_exit_code=$(check_database_installed &>/dev/null || echo $?)
      echo "Install check exit code: $install_check_exit_code"
      retries=$((retries - 1))
    done

    if [ "$install_check_exit_code" != "0" ] && [ "$install_check_exit_code" != "2" ]; then
      echo "Timeout waiting for database to be ready"
      echo "Last install check exit code: $install_check_exit_code"
      exit 1
    fi
  fi

  if [ "$install_check_exit_code" == "2" ]; then
    echo "Installing Moodle database"

    adminuser=${MOODLE_INSTALL_USER:-admin}
    adminpass=${MOODLE_INSTALL_PASS:-password}

    php ${DOCUMENT_ROOT}/admin/cli/install_database.php \
      --lang="${MOODLE_INSTALL_LANG:-en}" \
      --fullname="${MOODLE_INSTALL_FULLNAME:-Moodle}" \
      --shortname="${MOODLE_INSTALL_SHORTNAME:-moodle}" \
      --summary="${MOODLE_INSTALL_SUMMARY:-Summary}" \
      --adminuser="${adminuser}" \
      --adminpass="${adminpass}" \
      --adminemail="${MOODLE_INSTALL_EMAIL:-admin@example.com}" \
      --agree-license

    echo "Admin user: ${adminuser}"
    echo "Admin password: ${adminpass}"
  else
    echo "Database already installed"
  fi
else
  echo "Ommited unattended installation"
fi

# Remote xdebug host
gateway=$(awk 'END{print $1}' /etc/hosts |  awk -F "." '{print $1 "." $2 "." $3 "." 1}')
sed -i "s@dockerhost@${gateway}@" /usr/local/etc/php/conf.d/xdebug.ini

# Custom CA
if [ -f /usr/local/share/ca-certificates/custom-ca.crt ]; then
    update-ca-certificates
    if [ -f /usr/local/lib/python2.7/dist-packages/certifi/cacert.pem ]; then
        rm /usr/local/lib/python2.7/dist-packages/certifi/cacert.pem
        ln -s /usr/local/share/ca-certificates/custom-ca.crt /usr/local/lib/python2.7/dist-packages/certifi/cacert.pem
    fi
fi

# set listen port
sed -i "s@^listen.*@listen = ${PHP_FPM_PORT:-9000}@" /usr/local/etc/php-fpm.d/zz-docker.conf

docker-php-entrypoint "$@"
