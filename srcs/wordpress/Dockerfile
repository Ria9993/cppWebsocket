FROM debian:11

RUN apt update -y && apt install -y \
    wget \
    php  \
    curl \
    apache2\
    php7.4 \
    php7.4-curl \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-cli \
    php7.4-fpm\
    mariadb-client\
    dumb-init

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
