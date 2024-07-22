
FROM debian:11

RUN sudo apt update -y
RUN sudo apt install -y \
    wget \
    curl \
    nginx \
    openssl
RUN sudo apt install -y dumb-init

COPY ./Startup.sh /tmp/.
RUN sudo chmod +x /tmp/Startup.sh

COPY ./nginx.conf /etc/nginx/http.d/nginx.conf

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]
