FROM php:7.4-fpm as builder

USER root
WORKDIR /code
COPY . ./
RUN chown -R www-data:www-data /code


FROM php:7.4-fpm
WORKDIR /code
COPY --from=builder /code/app .
RUN docker-php-ext-install mysqli \
      pdo \
      xsl \
      gd
CMD ["php-fpm"]
