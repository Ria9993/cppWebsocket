
FROM debian:latest

RUN apt update -y
RUN apt install -y \
    wget \
    curl \
    mariadb-server
RUN apt install -y dump-init

COPY ./Startup.sh /tmp
RUN chmod +x /tmp/Startup.sh

COPY ./mariadb.cnf /etc/mysql/mariadb.cnf

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["/tmp/Startup.sh"]
