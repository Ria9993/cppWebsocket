
FROM debian:buster

RUN apt update && apt upgrade
RUN sudo apt install -y \
    mariadb-server
RUN sudo apt install -y dumb-init
    
# RUN mariadb-install-db --datadir=/var/lib/mysql/data --auth-root-authentication-method=normal

COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

RUN mysql_install_db

COPY ./50-server.cnf /tmp/.
COPY ./50-server.cnf /etc/mysql/mariadb.conf.d/.

EXPOSE 3306

# CMD /usr/bin/mysqld_safe --syslog

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]

