#!/bin/sh

set -e # if any command fails exit immediately

if [ ! -z "${MARIADB_DATA}" ]; then # if launched for the first time
    mariadb-install-db --user=${MARIADB_USER} \
                        --datadir=${MARIADB_DATA} \
                        --skip-test-db # initialise MariaDB system database as mysql user
    /usr/local/bin/secure_mariadb.sh # and secure it
fi

exec mariadbd --user=${MARIADB_USER} \
                --port=3306 \
                --bind-address=mariadb \
                --skip-networking=0 # Replace script process with MariaDB process