FROM php:7.4-fpm as builder
USER root
WORKDIR /code
COPY . ./
RUN chown -R www-data:www-data /code &&
    find vendor -name "*.php" -exec sed -i s@btn-primary@btn-success@g {} \;


FROM kuops/php:7.4-fpm
WORKDIR /code
COPY --from=builder /code .
CMD ["php-fpm"]
