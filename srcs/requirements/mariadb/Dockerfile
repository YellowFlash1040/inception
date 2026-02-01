FROM alpine:3.22.2

RUN apk add --no-cache mariadb

COPY ./tools/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]