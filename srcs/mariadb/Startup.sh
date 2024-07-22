#!/bin/sh

# set -e
# set -x

# Open external access to MariaDB

# mysql_install_db





if [ ! -d /var/lib/mysql/data/$DB_NAME ]; then
  # sed -i 's/bind-address/\# bind-address/g'  /etc/mysql/mariadb.cnf
  mysql_install_db
  /usr/share/mariadb/mysql.server start

  # DB Query
  mysql -e "\
  CREATE DATABASE IF NOT EXISTS ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; \
  CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PW}'; \
  GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%'; \
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ADMIN_PW}'; \
  FLUSH PRIVILEGES; \
  "
  mysqladmin --user=root shutdown
fi

mysqld_safe --datadir=/var/lib/mysql/data --user=root --port=3306