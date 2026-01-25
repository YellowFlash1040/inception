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

RUN rm -rf /tmp/* /var/cache/apk/*

RUN adduser -D -g '' nginxuser

EXPOSE 80

CMD [ "nginx" ]