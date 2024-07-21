FROM debian:11

RUN apt update -y
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
RUN apt install -y \
    mariadb-client
RUN apt install -y dumb-init


WORKDIR /var/www
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvf latest.tar.gz

RUN mkdir -p /var/www/wordpress
# RUN mv -f wordpress/* /var/www/wordpress
# RUN chown -R www-data:www-data /var/www/wordpress
RUN rm -rf wordpress latest.tar.gz


COPY ./Startup.sh /tmp/.
RUN chmod +x /tmp/Startup.sh

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD        ["sh", "-c", "/tmp/Startup.sh"]
