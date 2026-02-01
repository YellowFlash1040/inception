#!/bin/sh

set -e

if [ ! -d "${MARIADB_FOLDER}/mysql" ]; then
    mariadb-install-db --user=${MARIADB_LINUX_USER} \
                        --datadir=${MARIADB_FOLDER} \
                        --skip-test-db
    /usr/local/bin/secure_mariadb.sh
fi

exec mariadbd --user=${MARIADB_LINUX_USER} \
                --port=3306 \
                --bind-address=mariadb \
                --skip-networking=false \
                --skip-socket
