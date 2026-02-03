#!/bin/sh
set -e

if [ -z "$(ls -A ${WORDPRESS_DATA})" ]; then
    # Download WordPress with increased memory limit
    php -d memory_limit=256M /usr/local/bin/wp core download --allow-root --locale=en_US --path=${WORDPRESS_DATA}

    # Create config
    php -d memory_limit=256M /usr/local/bin/wp config create --allow-root --dbname=${WP_DATABASE} --dbuser=${WP_ADMIN_USER} --dbpass=${WP_PASSWORD} --dbhost=${WP_HOST} --path=${WORDPRESS_DATA}

    # Install WordPress
    php -d memory_limit=256M /usr/local/bin/wp core install --allow-root --url=${WP_URL} --title="${WP_TITLE}" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --path=${WORDPRESS_DATA}

    # Create user
    php -d memory_limit=256M /usr/local/bin/wp user create --allow-root "${WP_USER}" "${WP_EMAIL}" --user_pass="${WP_PASSWORD}" --role=author --path=${WORDPRESS_DATA}
    
    # Set proper ownership
    chown -R ${WORDPRESS_USER}:${WORDPRESS_USER} ${WORDPRESS_DATA}
fi

exec php-fpm84 -F