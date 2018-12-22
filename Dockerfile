FROM composer:1.7.3 AS composer

FROM php:7.2-fpm-alpine AS build
WORKDIR /var/www
COPY --chown=www-data ./ ./
USER www-data
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com \
    && composer install --no-ansi --no-dev --no-interaction --optimize-autoloader

FROM php:7.2-fpm

ENV TZ Asia/Shanghai
ENV PHP_DEPS libfreetype6-dev libjpeg62-turbo-dev \
             libpng-dev zlib1g-dev libicu-dev \
             unixodbc-dev libssl-dev libxslt-dev g++ apt-utils

# Install PHP extensions deps
RUN sed -ri 's@//.*.debian.org@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list \
    && sed -ri 's@//.*.debian.org@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/* \
    && apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y ${PHP_DEPS}

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd mbstring pdo_mysql \
       zip ftp xsl \
    && docker-php-ext-enable opcache

# Clean repository
RUN apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

# Copy app
WORKDIR /var/www
USER www-data
COPY --from=build --chown=www-data /var/www ./

CMD ["php-fpm"]
