FROM php:8.2-apache

RUN docker-php-ext-install mysqli \
    && a2enmod rewrite \
    && sed -ri 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

COPY source/ /var/www/html/
COPY overlay/config.php /var/www/html/files/config.php
COPY overlay/map_revolution.php /var/www/html/files/external/map_revolution.php
COPY bridge/ /var/www/html/bridge/

RUN printf '%s\n' 'auto_prepend_file=/var/www/html/bridge/prepend.php' > /usr/local/etc/php/conf.d/kalaazu-bridge.ini \
    && mkdir -p /var/www/html/files/sessions /var/www/html/files/error_logs \
    && chown -R www-data:www-data /var/www/html/files/sessions /var/www/html/files/error_logs

EXPOSE 80
