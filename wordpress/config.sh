set -x
set -e
# echo "define ('DB_NAME', '$DB_NAME')" ;
# echo "define ('DB_NAME', '$DB_NAME')" >> /etc/php/7.4/fpm/pool.d/www.conf ;
# echo "define ('DB_USER', '$DB_USER')" >> /etc/php/7.4/fpm/pool.d/www.conf ;
# echo "define ('DB_PASSWORD', '$DB_USER_PW')" >> /etc/php/7.4/fpm/pool.d/www.conf ;
# echo "define ('DB_HOST', 'mariadb:3306')" >> /etc/php/7.4/fpm/pool.d/www.conf ;
# echo "define( 'DB_CHARSET', 'utf8' );" >> /etc/php/7.4/fpm/pool.d/www.conf ;
# echo "define( 'DB_COLLATE', 'utf8_general_ci' );" >> /etc/php/7.4/fpm/pool.d/www.conf ;


#MARIA DB READY?
echo "Checking if MariaDB is ready at ${DB_HOST}:${DB_PORT}..."
COUNTER=0

while ! mysqladmin ping -hmariadb -u$DB_USER -p$DB_USER_PW --silent; do
  COUNTER=$((COUNTER + 1))
  
  if ${COUNTER} == ${TIMEOUT}; then
    echo "Error: COUNTER is not a valid number: $COUNTER"
    exit 1
  fi

  echo "Waiting for MariaDB... (${COUNTER}/${TIMEOUT})"
  sleep 1
done

echo "MariaDB is ready!"



#php fpm 파일 수정
sed -i 's|.*listen = .*$|listen = 0.0.0.0:9000|g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's|.*listen\.owner = .*$|listen\.owner = nginx|g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's|.*listen\.group = .*$|listen\.group = nginx|g' /etc/php/7.4/fpm/pool.d/www.conf
sed -i 's|;clear_env|clear_env|g' /etc/php/7.4/fpm/pool.d/www.conf
echo "env[DB_NAME] = $DB_DATABASE" >> /etc/php/7.4/fpm/pool.d/www.conf ;
echo "env[DB_TABLE] = $DB_TABLE" >> /etc/php/7.4/fpm/pool.d/www.conf ;
echo "env[DB_HOST] = $DB_HOST" >> /etc/php/7.4/fpm/pool.d/www.conf ;
echo "env[DB_USER] = $DB_USER" >> /etc/php/7.4/fpm/pool.d/www.conf ;
echo "env[DB_PASSWORD] = $DB_USER_PW" >> /etc/php/7.4/fpm/pool.d/www.conf ;


#wp-cli 

if ! [ -f "/wpclidemo.dev" ]; then 
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp #경우에 따라 sudo 필요
	wp cli update #경우에 따라 sudo 필요
	wp core download --allow-root --path=wpclidemo.dev
	cd wpclidemo.dev
	wp config create --allow-root \
		--dbname=$DB_DATABASE \
		--dbuser=$DB_USER \
		--prompt=dbpass \
		--dbpass=$DB_USER_PW \
		--dbhost=mariadb:3306
	wp core install --allow-root \
		--url="http://$DOMAIN" \
		--title="SIWOLEE🤢INCEPTION" \
		--admin_user="$DB_ADMIN" \
		--admin_password="$DB_ADMIN_PWD" \
		--admin_email="$EMAIL" 
	wp user create --allow-root \
		$WP_USER $WP_USER_MAIL \
		--role=author \
		--user_pass=$WP_USER_PW
fi
# do i have to remember admin password after installation?

# exec "$@"  
# cd ..

# /etc/init.d/php7.4-fpm start --nodaemonize
# wait 3000;
# mkdir /run/php && php-fpm7.4 --nodaemonize
if ! [ -f "/run/php" ]; then 
	mkdir -p /run/php; 
fi
php-fpm7.4 --nodaemonize

