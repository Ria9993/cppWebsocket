#!/bin/sh

if ! [ -d "/etc/nginx/ssl" ]; then
    mkdir /etc/nginx/ssl
    openssl req -newkey rsa:4096 -days 365 -nodes -x509 \
            -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=NA/CN=hyunjunk" \
            -keyout /etc/nginx/ssl/hyunjunk\.42.fr.key -out /etc/nginx/ssl/hyunjunk\.42.fr.crt
    mkdir -p /run/nginx
fi

nginx -g "daemon off;"