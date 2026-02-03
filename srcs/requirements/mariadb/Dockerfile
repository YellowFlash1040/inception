FROM alpine:3.22.2

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY ./*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]