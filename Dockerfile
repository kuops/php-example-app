FROM composer:1.7.3 AS composer

FROM kuopsme/php:7.2-fpm-alpine AS build
WORKDIR /var/www
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --chown=www-data ./ ./
USER www-data
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com \
    && composer install  --no-ansi --no-dev --no-interaction --optimize-autoloader

FROM kuopsme/php:7.2-fpm-alpine
WORKDIR /var/www
USER www-data
COPY --from=build --chown=www-data /var/www ./

CMD ["php-fpm"]
