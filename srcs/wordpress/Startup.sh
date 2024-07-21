#!/bin/sh


# Monitoring environment variables
echo "env[DB_NAME] = $DB_DATABASE" >> ${PHP_FPM_POOL_CONF}
echo "env[DB_TABLE] = $DB_TABLE" >> ${PHP_FPM_POOL_CONF}
echo "env[DB_HOST] = $DB_HOST" >> ${PHP_FPM_POOL_CONF}
echo "env[DB_USER] = $DB_USER" >> ${PHP_FPM_POOL_CONF}
echo "env[DB_PASSWORD] = $DB_USER_PW" >> ${PHP_FPM_POOL_CONF}

# @see https://dev.mysql.com/doc/refman/8.0/en/mysqladmin.html
POLLING_INTERVAL=1
POLLING_COUNTER=0
while ! mysqladmin ping --silent -hmariadb -u$DB_USER -p$DB_USER_PW; do
  POLLING_COUNTER=$((POLLING_COUNTER + 1))
  if [ "$POLLING_COUNTER" -eq "$WAIT_TIMEOUT" ]; then
    echo "MariaDB is not ready. (WaitTime=${POLLING_COUNTER})"
    exit 1
  fi
  sleep ${POLLING_INTERVAL}
done
echo "Checked MariaDB alive."


# Set up default listening port and owner 
PHP_VERSION=7.4
PHP_FPM_POOL_CONF="/etc/php/$PHP_VERSION/fpm/pool.d/www.conf"
sed -i 's|.*listen = .*$|listen = 0.0.0.0:9000|g' ${PHP_FPM_POOL_CONF}
sed -i 's|.*listen\.owner = .*$|listen\.owner = nginx|g' ${PHP_FPM_POOL_CONF}
sed -i 's|.*listen\.group = .*$|listen\.group = nginx|g' ${PHP_FPM_POOL_CONF}
sed -i 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' ${PHP_FPM_POOL_CONF}
sed -i 's|;clear_env|clear_env|g' ${PHP_FPM_POOL_CONF}


# wp-cli. Set up the WordPress
if ! [ -e "/var/www/wordpress/wp-config.php" ]; then 

  # @see https://make.wordpress.org/cli/handbook/guides/installing/#recommended-installation
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod +x wp-cli.phar
  mv -f wp-cli.phar /usr/local/bin/wp

  wp core download --allow-root
  wp config create --allow-root \
    --dbname=$DB_DATABASE \
    --dbuser=$DB_USER \
    --dbpass=$DB_USER_PW \
    --dbhost=mariadb:$DB_PORT \
    --skip-check
  wp core install --allow-root \
    --url=$DOMAIN_NAME \
    --title=$WP_TITLE \
    --admin_user=$WP_USER \
    --admin_password=$WP_USER_PW \
    --admin_email=$WP_USER_EMAIL
  wp user create --allow-root \
    $WP_USER \
    $WP_USER_EMAIL \
    --user_pass=$WP_USER_PW
else
  echo "[ASSERTION FAILED] wp-cli is already installed."
fi

# Start PHP-FPM without daemonize
/usr/sbin/php-fpm7.4 -F