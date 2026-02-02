# Download Wordpress
FROM alpine:3.22.2 AS curlstage

RUN apk update && apk add --no-cache curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# WordPress
FROM alpine:3.22.2

RUN apk update && apk add --no-cache \
    php84 \
    php84-fpm \
    php84-mysqli \
    php84-pdo_mysql \
    php84-json \
    php84-curl \
    php84-gd \
    php84-mbstring \
    php84-openssl \
    php84-xml \
    php84-session \
    php84-phar \
    php84-dom \
    php84-xmlreader \
    php84-ctype \
    php84-zlib \
    php84-intl \
    su-exec \
    mysql-client

# Create symlink so 'php' command works
RUN ln -s /usr/bin/php84 /usr/bin/php

COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN adduser -D wordpress

RUN mkdir -p /var/log/php84 \
    && chown wordpress:wordpress /var/log/php84

COPY --from=curlstage /usr/local/bin/wp /usr/local/bin/wp

WORKDIR /var/www/html/wordpress

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]