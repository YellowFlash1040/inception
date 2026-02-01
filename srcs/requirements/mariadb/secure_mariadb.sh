#!/bin/sh

set -e

if [ ! -d "${MARIADB_SOCKET_FOLDER}" ]; then
    mkdir -p ${MARIADB_SOCKET_FOLDER}
    chown ${MARIADB_LINUX_USER}:${MARIADB_LINUX_USER} ${MARIADB_SOCKET_FOLDER}
fi

mariadbd --user=${MARIADB_LINUX_USER} &
pid="$!"

until mariadb-admin ping --socket=${MARIADB_SOCKET_FOLDER}/mysqld.sock --silent; do
    sleep 1
done

mariadb --protocol=socket -uroot <<-EOSQL
    DELETE FROM mysql.user WHERE User='';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_USER_PASSWORD}';

    CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME};
    CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_USER_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%';

    FLUSH PRIVILEGES;
EOSQL

mariadb-admin --protocol=socket -uroot -p"${MARIADB_ROOT_USER_PASSWORD}" shutdown
wait "$pid" 2>/dev/null || true
