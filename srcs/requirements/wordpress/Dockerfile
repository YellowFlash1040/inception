# Download Wordpress
FROM alpine:3.22.2 AS curlstage

RUN apk update && apk add --no-cache curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && chmod +x /usr/local/bin/wp

# WordPress
FROM alpine:3.22.2

RUN apk update && apk add --no-cache \
    php84 \
    php84-fpm \
    php84-mysqli \
    php84-phar \
    php84-mbstring

COPY --from=curlstage /usr/local/bin/wp /usr/local/bin/wp

COPY ./www.conf /etc/php84/php-fpm.d/

RUN adduser -D wordpress

COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]