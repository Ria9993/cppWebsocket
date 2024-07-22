
FROM debian:buster

RUN apt update && apt install -y \
    dumb-init mariadb-server mariadb-common mariadb-client mysql-common

COPY ./50-server.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN /usr/bin/mysql_install_db --datadir=/var/lib/mysql/data --auth-root-authentication-method=normal --defaults-file=/etc/my.cnf.d/mariadb-server.cnf

RUN mkdir -p /var/run/mysqld/\
&& mkdir -p /var/lib/mysql/data/\
\
&& chmod 755 -R /var/lib/mysql\
\
&& touch /var/run/mysqld/mysqld.sock\
&& chmod 755 /var/run/mysqld/mysqld.sock\
&& chown root:mysql /var/run/mysqld/mysqld.sock\
\
&& touch /var/log/mysqld.log\
&& chmod 660 /var/log/mysqld.log\
&& chown root:mysql /var/log/mysqld.log\
\
&& chown -R root:mysql /var/run/mysqld\
&& chown -R root:mysql /var/lib/mysql\
\
&& rm -f /etc/my.cnf.d/mariadb-server.cnf
    

COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

# RUN mysql_install_db


EXPOSE 3306

# CMD /usr/bin/mysqld_safe --syslog

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]

