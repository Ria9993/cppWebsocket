#!/bin/sh

PHP_VERSION=php82
PHP_FPM_POOL_CONF="/etc/$PHP_VERSION/php-fpm.d/www.conf"
echo "env[DB_NAME] = $DB_DATABASE" >> ${PHP_FPM_POOL_CONF}
echo "env[DB_TABLE] = $DB_TABLE" >> ${PHP_FPM_POOL_CONF}
echo "env[DB_HOST] = $DB_HOST" >> ${PHP_FPM_POOL_CONF}
echo "env[DB_USER] = $DB_USER" >> ${PHP_FPM_POOL_CONF}
echo "env[DB_PASSWORD] = $DB_USER_PW" >> ${PHP_FPM_POOL_CONF}


# @see https://dev.mysql.com/doc/refman/8.0/en/mysqladmin.html
POLLING_INTERVAL=1
POLLING_COUNTER=0

until mysql --host=$DB_HOST --user=$DB_USER --password=$DB_USER_PWD -e '\c'; do
  echo >&2 "mariadb is unavailable - sleeping"
  POLLING_COUNTER=$((POLLING_COUNTER + 1))
  if [ "$POLLING_COUNTER" -eq "$WAIT_TIMEOUT" ]; then
    echo "MariaDB is not ready. (WaitTime=${POLLING_COUNTER})"
    exit 1
  fi
  sleep ${POLLING_INTERVAL}
done
echo "Checked MariaDB alive."


# Set up default listening port and owner 
sed -i 's|.*listen = .*$|listen = 0.0.0.0:9000|g' ${PHP_FPM_POOL_CONF}
sed -i 's|.*listen\.owner = .*$|listen\.owner = nginx|g' ${PHP_FPM_POOL_CONF}
sed -i 's|.*listen\.group = .*$|listen\.group = nginx|g' ${PHP_FPM_POOL_CONF}
sed -i 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' ${PHP_FPM_POOL_CONF}
sed -i 's|;clear_env|clear_env|g' ${PHP_FPM_POOL_CONF}


rm -f /var/www/html/wp-config.php
chown -R www-data:www-data /var/www/html
/wp-cli.phar config create --allow-root --dbname="$WP_DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_USER_PWD" --dbhost="$DB_HOST" --dbcharset=utf8mb4 --path=/var/www/html

wp core install --url="$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL" --skip-email --path=/var/www/html --allow-root

wp user create "$WP_USER" "$WP_USER_EMAIL" --role=author --user_pass="$WP_USER_PWD" --allow-root --path=/var/www/html

if [ ! -f "/var/www/html/wp-config.php" ]; then
	exit 1
fi

# Start PHP-FPM without daemonize
php-fpm82 --nodaemonize
