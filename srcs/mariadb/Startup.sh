#!/bin/sh

# Open external access to MariaDB
if [ ! -e "/run/mysqld/mysqld.sock" ]; then
  mysql_install_db
  /usr/share/mariadb/mysql.server start
  /etc/init.d/mysql start
  mysqladmin -u root -p status

  sed -i 's/bind-address/\# bind-address/g'  /etc/mysql/mariadb.cnf

  # Start MariaDB
  while ! mysqladmin --user=root ping; do
      sleep 1
  done

  # DB Query
  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
  mysql -uroot -e "USE $DB_NAME;"
  mysql -uroot -e "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_USER_PW';"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PW';"
  mysql -uroot -e "FLUSH PRIVILEGES;"

  #mysqladmin -uroot -p shutdown
  while ! mysqladmin --user=root ping; do
      sleep 1
  done

  mysqladmin --user=root shutdown

fi

mysqld_safe --datadir=/var/lib/mysql/data --user=root --port=3306