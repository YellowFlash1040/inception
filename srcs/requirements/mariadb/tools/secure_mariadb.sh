#!/bin/sh

set -e

if [ ! -d "${MARIADB_SOCKET_FOLDER}" ]; then # if MariaDB unix socket directory is missing
    mkdir -p ${MARIADB_SOCKET_FOLDER} # create one
    chown ${MARIADB_USER}:${MARIADB_USER} ${MARIADB_SOCKET_FOLDER} # and set appropriate ownership
fi

mariadbd --user=${MARIADB_USER} & # Start MariaDB temporarily in the background
pid="$!" # And capture it's pid

until mariadb-admin ping --socket=${MARIADB_SOCKET_FOLDER}/mysqld.sock --silent; do
    sleep 1
done

# mariadb-admin ping → Checks if MariaDB is running and responding.
# --socket=.../mysqld.sock → Connects via the UNIX socket.
# --silent → Only returns exit code, no output.
# this loop sleeps 1 second if mariadb-admin tool can not connect to the database

mariadb --protocol=socket -uroot <<-EOSQL
    DELETE FROM mysql.user WHERE User='';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

# This block ↑ connects to MariaDB as root user using the socket and executes multiple SQL statements.
# <<- is a Here-document with tab-stripping. Whereas << is a Here-document without special whitespace handling.
# Removes all anonymous users
# Sets the root password to whatever is in MARIADB_ROOT_PASSWORD.
# Removes the default "test" database.
# Removes privileges related to the "test" database.
# Reloads the privilege tables so changes take effect immediately.

mariadb-admin --protocol=socket -uroot -p"${MARIADB_ROOT_PASSWORD}" shutdown
wait "$pid" 2>/dev/null || true

# mariadb-admin shutdown → Gracefully stops the MariaDB server
# Connects via socket as root using the password we just set.
# wait "$pid" → Waits for the process to fully terminate.

# if wait "$pid" fails because the process already exited,
# 2>/dev/null → Redirects stderr to /dev/null, so any error messages, like:
# "bash: wait: pid 12345 is not a child of this shell"
# are hidden.
# || true → Ensures the script does not exit with an error, due to "wait fail" + "set -e"
# but with a success instead, so that the entrypoint.sh will succeed as well
