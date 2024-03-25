# Set the base image for subsequent instructions
FROM php:8.2-fpm as php

ENV COMPOSER_ALLOW_SUPERUSER=1


# Install PHP extensions and dependencies
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        zlib1g-dev \
        unzip \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        sockets \
        zip

# Clear out the local repository of retrieved package files
RUN apt-get clean

# Create application directory
RUN mkdir /app
WORKDIR /app

# Copying this early allows Docker to cache the downloaded packages between builds
COPY composer.json composer.lock ./

# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install project dependencies
RUN composer install --no-scripts --no-autoloader --ignore-platform-req=ext-intl --ignore-platform-req=ext-mysqli --ignore-platform-req=ext-gd

# Copy the rest of your application code
COPY . .

# Finish composer installation
# RUN composer dump-autoload --optimize --classmap-authoritative --no-dev

# Start the PHP FPM server
CMD php artisan serve --host=0.0.0.0 --port=8000
EXPOSE 8000
