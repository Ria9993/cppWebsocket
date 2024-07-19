FROM debian:latest

RUN apt update
RUN apt install -y \
    wget \
    php  \
    curl \
    apache2
RUN apt install -y \
    php7.4 \
    php7.4-curl \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-cli \
    php7.4-fpm


WORKDIR /var/www
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz

RUN mkdir -p /var/www/wordpress
RUN mv wordpress/* /var/www/wordpress
# RUN chown -R www-data:www-data /var/www/wordpress
RUN rm -rf wordpress latest.tar.gz
RUN mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php


COPY ./Installer.sh /tmp
RUN chmod +x /tmp/Installer.sh


ENTRYPOINT /tmp/Installer.sh
