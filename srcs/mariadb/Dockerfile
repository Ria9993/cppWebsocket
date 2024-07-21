
FROM debian:buster

RUN apt update -y
RUN apt install -y \
    mariadb-server
RUN apt install -y dumb-init
    
# RUN mariadb-install-db --datadir=/var/lib/mysql/data --auth-root-authentication-method=normal

COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/.

EXPOSE 3306

RUN bash /tmp/Startup.sh

CMD /usr/bin/mysqld_safe
