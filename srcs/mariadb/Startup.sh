#!/bin/sh

# Open external access to MariaDB
if ! [ -f //etc/mysql/mariadb.cnf ]; then
  echo "[Assertion Failed] MariaDB configuration file is not found."
fi
sed -i 's/bind-address/\# bind-address/g'  /etc/mysql/mariadb.cnf

# Start MariaDB
service mysql start
while ! mysqladmin ping; do
    sleep 1
done

# DB Query
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -uroot -e "USE $DB_NAME;"
mysql -uroot -e "CREATE USER $DB_USER@'%' IDENTIFIED BY '$DB_USER_PW';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PW';"
mysql -uroot -e "FLUSH PRIVILEGES;"

#mysqladmin -uroot -p shutdown
while ! mysqladmin ping; do
    sleep 1
done

service mariadb stop
exec mysqld
