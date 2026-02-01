#!/bin/sh
set -e

alias wp='php -d memory_limit=256M /usr/local/bin/wp'

# Download WordPress if not present
if [ ! -d "${WORDPRESS_FOLDER}/wp-admin" ]; then
    wp core download --allow-root --locale=en_US --path=${WORDPRESS_FOLDER}
    chown -R ${WP_LINUX_USER}:${WP_LINUX_USER} ${WORDPRESS_FOLDER}
fi

# Wait for database to start
until nc -z ${WP_DB_HOST} 3306 2>/dev/null; do
    sleep 3
done

# Create config if it doesn't exist
if [ ! -f "${WORDPRESS_FOLDER}/wp-config.php" ]; then
    wp config create --allow-root \
        --dbhost=${WP_DB_HOST} \
        --dbname=${WP_DB_NAME} \
        --dbuser=${WP_ADMIN_USER} \
        --dbpass=${WP_PASSWORD} \
        --path=${WORDPRESS_FOLDER}
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root --path=${WORDPRESS_FOLDER} 2>/dev/null; then
    wp core install --allow-root \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --path=${WORDPRESS_FOLDER}
fi

# Create user if it doesn't exist
if ! wp user get "${WP_USER}" --allow-root --path=${WORDPRESS_FOLDER} 2>/dev/null; then
    wp user create --allow-root \
        "${WP_USER}" "${WP_EMAIL}" \
        --user_pass="${WP_PASSWORD}" \
        --role=author \
        --path=${WORDPRESS_FOLDER}
fi

exec php-fpm84 -F