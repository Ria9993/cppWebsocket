
FROM debian:11

RUN apt update -y
RUN apt install -y \
    wget \
    curl \
    mariadb-server
RUN apt install -y dumb-init

COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

COPY ./mariadb.cnf /etc/mysql/mariadb.cnf

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]
