#!/bin/sh

set -e
set -x

# Open external access to MariaDB

# mysql_install_db



service mysql start


if [ ! -d "/var/lib/mysql/data/wordpress" ]; then
  # sed -i 's/bind-address/\# bind-address/g'  /etc/mysql/mariadb.cnf

  # DB Query
  # mysql -e "\
  #       CREATE DATABASE IF NOT EXISTS $DB_NAME; \
  #       CREATE USER IF NOT EXISTS '{$DB_USER}'@'%' IDENTIFIED BY '$DB_USER_PW'; \
  #       GRANT ALL ON $DB_NAME.* TO '{$DB_USER}'@'%'; \
  #       ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ADMIN_PW'; \
  #       FLUSH PRIVILEGES;"

  mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
  mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PW}';"
  mysql -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ADMIN_PW}';"
  mysql -e "FLUSH PRIVILEGES;"
fi

service mysql stop


mysqld_safe
