FROM php:7.4-fpm as builder

USER root
WORKDIR /code
COPY . ./
RUN chmod -R www-data:www-data /code


FROM php:7.4-fpm
WORKDIR /code
COPY --from=builder /code/app .
CMD ["php-fpm"]
