FROM FROM php:7.4-fpm

WORKDIR /code
USER www-data
COPY . ./
CMD ["php-fpm"]
