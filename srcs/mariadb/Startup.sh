#!/bin/sh

# Open external access to MariaDB

mysql_install_db

/etc/init.d/mysql start


if [ ! -d "/var/lib/mysql/wordpress" ]; then
  # sed -i 's/bind-address/\# bind-address/g'  /etc/mysql/mariadb.cnf
  
  # DB Query
  mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
  mysql -uroot -e "USE $DB_NAME;"
  mysql -uroot -e "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_USER_PW';"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PW';"
  mysql -uroot -e "FLUSH PRIVILEGES;"
fi

/etc/init.d/mysql stop

mysqld_safe --datadir=/var/lib/mysql/data --user=root --port=3306 --default-file=/tmp