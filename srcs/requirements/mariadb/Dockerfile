FROM alpine:3.22.2

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY ./tools/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]