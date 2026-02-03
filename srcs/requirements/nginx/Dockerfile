# Create certificate
FROM alpine:3.22.2 AS certificate

RUN apk update && apk add --no-cache openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=NL/L=Amsterdam/O=Codam/CN=Andrii Kovtunets/emailAddress=akovtune@student.codam.nl"

# NGINX
FROM alpine:3.22.2

RUN apk add --no-cache nginx

COPY --from=certificate /etc/nginx/ssl /etc/nginx/ssl
RUN chown -R nginx:nginx /etc/nginx/ssl/

COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

USER nginx

ENTRYPOINT ["nginx", "-g", "daemon off;"]