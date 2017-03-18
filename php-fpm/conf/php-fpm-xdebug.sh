#!/bin/bash -e

# Remote xdebug host
sed -i "s@dockerhost@$(/sbin/ip route|awk '/default/ { print $3 }')@" /usr/local/etc/php/conf.d/xdebug.ini
# Start php-fpm
php-fpm
