#!/bin/sh

# Open external access to MariaDB
if [ ! -e "/run/mysqld/mysqld.sock" ]; then
  mysql_install_db
  mysqld_safe 

  sed -i 's/bind-address/\# bind-address/g'  /etc/mysql/mariadb.cnf

  # Start MariaDB
  while ! mysqladmin -uroot ping; do
      sleep 1
  done

  # DB Query
  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
  mysql -uroot -e "USE $DB_NAME;"
  mysql -uroot -e "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_USER_PW';"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PW';"
  mysql -uroot -e "FLUSH PRIVILEGES;"

  mysqladmin --user=root shutdown

fi

service mysql start
mysqld_safe --datadir=/var/lib/mysql/data --user=root --port=3306 --default-file=/tmp