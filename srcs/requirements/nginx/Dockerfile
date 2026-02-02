# Certificates
FROM alpine:3.22.2 AS certs

RUN apk add --no-cache openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/L=Paris/O=42 Paris/CN=Student/emailAddress=wil@student.42.fr"

# NGINX
FROM alpine:3.22.2

RUN apk add --no-cache nginx

COPY --from=certs /etc/nginx/ssl /etc/nginx/ssl

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]