FROM alpine

RUN apk add --no-cache openssl curl ca-certificates
RUN printf "%s%s%s%s\n" \
    "@nginx " \
    "https://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories

RUN curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub
RUN mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/

RUN apk add --no-cache nginx@nginx
# The nginx package already creates a system user and group called nginx.

RUN rm -rf /tmp/* /var/cache/apk/* /etc/apk/keys/

RUN mkdir /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/akovtune.key \
    -out /etc/nginx/ssl/akovtune.crt \
    -subj "/C=NL/L=Amsterdam/O=Codam/CN=Andrii Kovtunets/emailAddress=akovtune@student.codam.nl"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]