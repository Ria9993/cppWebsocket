FROM alpine:3.19.2

RUN apk update && apk upgrade && apk add curl openssl nginx\
&& mkdir -p /etc/nginx/ssl\
&& wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64\
&& chmod +x /usr/local/bin/dumb-init\
&& mkdir -p /var/run/nginx

RUN openssl req -newkey rsa:4096 -days 365 -x509 -nodes \
-subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=hyunjunk/CN=hyunjunk\.42.fr" \
-keyout /etc/nginx/ssl/hyunjunk\.42.fr.key -out /etc/nginx/ssl/hyunjunk\.42.fr.crt\
&& rm /etc/nginx/http.d/default.conf\
&& rm /etc/nginx/nginx.conf

COPY		config/nginx.conf /etc/nginx/nginx.conf

STOPSIGNAL SIGQUIT

ENTRYPOINT	[ "/usr/local/bin/dumb-init", "--" ]
CMD			[ "nginx", "-g", "daemon off;" ]