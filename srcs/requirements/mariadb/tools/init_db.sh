#!/bin/sh

MARIADB_HOME="/var/lib/mysql"

if [ ! -d "${MARIADB_HOME}/mysql" ]; then
    mysql_install_db --user=mysql --datadir=${MARIADB_HOME}
    chown -R mysql:mysql /var/lib/mysql
fi

exec mysqld --user=mysqld