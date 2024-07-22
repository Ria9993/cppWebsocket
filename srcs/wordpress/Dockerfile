FROM debian:11

RUN apt update -y && apt install -y \
curl wget php8.2 php8.2-fpm php8.2-cgi php8.2-phar php8.2-mysqli php8.2-curl php8.2-iconv mariadb-client

WORKDIR /var/www
RUN wget https://wordpress.org/latest.tar.gz\
&& tar -xvf latest.tar.gz\
&& mkdir -p /var/www/wordpress\
&& rm -rf wordpress latest.tar.gz

# RUN mv -f wordpress/* /var/www/wordpress
# RUN chown -R www-data:www-data /var/www/wordpress

COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]
