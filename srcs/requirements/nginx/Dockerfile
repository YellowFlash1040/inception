FROM alpine:3.22.2

RUN apk add --no-cache openssl nginx

RUN mkdir /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/L=Paris/O=42 Paris/CN=Student/emailAddress=wil@student.42.fr"

COPY ./conf/nginx.conf /etc/nginx/

COPY ./index.html /var/www/html/index.html

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]