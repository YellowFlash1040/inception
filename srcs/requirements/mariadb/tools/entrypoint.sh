#!/bin/sh

set -e # if any command fails exit immediately

MARIADB_USER="mysql"
MARIADB_HOME="/var/lib/mysql"
MARIADB_SOCKET_FOLDER="/run/mysqld"

if [ ! -d "${MARIADB_HOME}/mysql" ]; then # if launched for the first time
    mariadb-install-db --user=${MARIADB_USER} --datadir=${MARIADB_HOME} # initialise MariaDB system database as mysql user
    /usr/local/bin/secure_mariadb.sh
fi

if [ ! -d "${MARIADB_SOCKET_FOLDER}" ]; then # if MariaDB unix socket directory is missing
    mkdir -p ${MARIADB_SOCKET_FOLDER} # create one
    chown -R ${MARIADB_USER}:${MARIADB_USER} ${MARIADB_SOCKET_FOLDER} # and set appropriate ownership
fi

exec mariadbd --user=${MARIADB_USER} # Replace script process with MariaDB process

#------------------
#mariadb-install-db --datadir=/var/lib/mysql
#chown -R mysql:mysql /var/lib/mysql
#mkdir -p /run/mysqld
#chown mysql:mysql /run/mysqld
#mariadbd --user=mysql & |or| mariadbd-safe --user=mysql &
#mariadb-secure-installation