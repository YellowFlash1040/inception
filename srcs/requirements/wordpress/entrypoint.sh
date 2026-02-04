#!/bin/sh
set -e

alias wp='php -d memory_limit=256M /usr/local/bin/wp'

# Download WordPress if not present
if [ ! -d "${WP_FOLDER}/wp-admin" ]; then
    wp core download --allow-root --locale=en_US --path=${WP_FOLDER}
    chown -R ${WP_LINUX_USER}:${WP_LINUX_USER} ${WP_FOLDER}
fi

# Create config if it doesn't exist
if [ ! -f "${WP_FOLDER}/wp-config.php" ]; then
    wp config create --allow-root \
        --dbhost=${WP_DB_HOST} \
        --dbname=${WP_DB_NAME} \
        --dbuser=${WP_DB_USER} \
        --dbpass=${WP_DB_USER_PASSWORD} \
        --path=${WP_FOLDER}
fi

# Wait for database to start
until nc -z ${WP_DB_HOST} 3306 2>/dev/null; do
    sleep 3
done

# Install WordPress if not already installed
if ! wp core is-installed --allow-root --path=${WP_FOLDER} 2>/dev/null; then
    wp core install --allow-root \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --path=${WP_FOLDER}
fi

# Create second user if it doesn't exist
if ! wp user get "${SECOND_WP_USER}" --allow-root --path=${WP_FOLDER} 2>/dev/null; then
    wp user create --allow-root \
        "${SECOND_WP_USER}" "${SECOND_WP_USER_EMAIL}" \
        --user_pass="${SECOND_WP_USER_PASSWORD}" \
        --role=author \
        --path=${WP_FOLDER}
fi

exec php-fpm84 -F