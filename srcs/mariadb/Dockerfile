
FROM debian:buster

RUN apt update && apt install -y \
    mariadb-server dumb-init mariadb mariadb-client mysql\
&& mkdir -p /run/mysqld/\
&& mkdir -p /var/lib/mysql/data/\
\
&& chmod 755 -R /var/lib/mysql\
\
&& touch /run/mysqld/mysqld.sock\
&& chmod 755 /run/mysqld/mysqld.sock\
&& chown root:mysql /run/mysqld/mysqld.sock\
\
&& touch /var/log/mysqld.log\
&& chmod 660 /var/log/mysqld.log\
&& chown root:mysql /var/log/mysqld.log\
\
&& chown -R root:mysql /run/mysqld\
&& chown -R root:mysql /var/lib/mysql\
\
&& rm -f /etc/my.cnf.d/mariadb-server.cnf
    
RUN mariadb-install-db --datadir=/var/lib/mysql/data --auth-root-authentication-method=normal

COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

COPY ./50-server.cnf /etc/my.cnf.d/mariadb-server.cnf
# RUN mysql_install_db


EXPOSE 3306

# CMD /usr/bin/mysqld_safe --syslog

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]

