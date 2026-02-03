#!/bin/sh
set -e

wp='php84 -d memory_limit=256M /usr/local/bin/wp'

# Download WordPress if not present
if [ ! -d "${WORDPRESS_DATA}/wp-admin" ]; then
    ${wp} core download --allow-root --locale=en_US --path=${WORDPRESS_DATA}
    chown -R ${WORDPRESS_USER}:${WORDPRESS_USER} ${WORDPRESS_DATA}
fi

# Wait for database to start
until nc -z ${WP_HOST} 3306 2>/dev/null; do
    sleep 3
done

# Create config if it doesn't exist
if [ ! -f "${WORDPRESS_DATA}/wp-config.php" ]; then
    ${wp} config create --allow-root \
        --dbname=${WP_DATABASE} \
        --dbuser=${WP_ADMIN_USER} \
        --dbpass=${WP_PASSWORD} \
        --dbhost=${WP_HOST} \
        --path=${WORDPRESS_DATA}
fi

# Install WordPress if not already installed
if ! ${wp} core is-installed --allow-root --path=${WORDPRESS_DATA} 2>/dev/null; then
    echo "Installing WordPress..."
    ${wp} core install --allow-root \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --path=${WORDPRESS_DATA}
fi

# Create user if it doesn't exist
if ! ${wp} user get "${WP_USER}" --allow-root --path=${WORDPRESS_DATA} 2>/dev/null; then
    echo "Creating user ${WP_USER}..."
    ${wp} user create --allow-root \
        "${WP_USER}" "${WP_EMAIL}" \
        --user_pass="${WP_PASSWORD}" \
        --role=author \
        --path=${WORDPRESS_DATA}
fi

exec php-fpm84 -F