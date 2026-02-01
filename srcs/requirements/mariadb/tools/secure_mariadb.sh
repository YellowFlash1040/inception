#!/bin/sh
set -e

MARIADB_USER="mysql"
MARIADB_SOCKET_FOLDER="/run/mysqld"
ROOT_PASSWORD="password"

if [ ! -d "${MARIADB_SOCKET_FOLDER}" ]; then # if MariaDB unix socket directory is missing
    mkdir -p ${MARIADB_SOCKET_FOLDER} # create one
    chown -R ${MARIADB_USER}:${MARIADB_USER} ${MARIADB_SOCKET_FOLDER} # and set appropriate ownership
fi

# Start MariaDB temporarily in the background
mariadbd --user=mysql --skip-networking &
# And capture it's pid
pid="$!"

# Wait until the socket is ready
until mariadb-admin ping --socket=${MARIADB_SOCKET_FOLDER}/mysqld.sock --silent; do
    sleep 1
done

# Run SQL commands to secure MariaDB
mariadb --protocol=socket -uroot <<-EOSQL
    DELETE FROM mysql.user WHERE User='';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;
EOSQL

# Stop temporary server
mariadb-admin --protocol=socket -uroot -p"${ROOT_PASSWORD}" shutdown
wait "$pid" 2>/dev/null || true
