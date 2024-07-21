
FROM debian:buster

RUN apt update -y
RUN apt install -y \
    mariadb-server
RUN apt install -y dumb-init
    
# RUN mariadb-install-db --datadir=/var/lib/mysql/data --auth-root-authentication-method=normal

COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

COPY ./my.cnf /etc/mysql/mariadb.conf.d/.
RUN chmod 755 /etc/mysql/mariadb.conf.d/my.cnf

EXPOSE 3306

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]
