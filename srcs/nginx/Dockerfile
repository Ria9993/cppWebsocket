
FROM debian:11

RUN apt update -y
RUN apt install -y \
    wget \
    curl \
    nginx \
    openssl
RUN apt install -y dumb-init

COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

COPY ./nginx.conf /etc/nginx/http.d/nginx.conf

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]
