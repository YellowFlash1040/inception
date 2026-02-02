#!/bin/sh

set -e # if any command fails exit immediately

if [ ! -d "${MARIADB_DATA}/mysql" ]; then # if launched for the first time
    mariadb-install-db --user=${MARIADB_USER} --datadir=${MARIADB_DATA} # initialise MariaDB system database as mysql user
    /usr/local/bin/secure_mariadb.sh # and secure it
fi

if [ ! -d "${MARIADB_SOCKET_FOLDER}" ]; then # if MariaDB unix socket directory is missing
    mkdir -p ${MARIADB_SOCKET_FOLDER} # create one
    chown -R ${MARIADB_USER}:${MARIADB_USER} ${MARIADB_SOCKET_FOLDER} # and set appropriate ownership
fi

exec mariadbd --user=${MARIADB_USER} \
                --port=3306 \
                --bind-address=0.0.0.0 \
                --skip-networking=0 # Replace script process with MariaDB process