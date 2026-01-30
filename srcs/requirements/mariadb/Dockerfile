FROM alpine:3.22.2

RUN apk add --no-cache mariadb mariadb-client

EXPOSE 3306

USER mysql

ENTRYPOINT ["sh", "-c", "tail -f /dev/null"]