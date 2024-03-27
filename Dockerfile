# Use the official PHP image with the Apache web server
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    zip \
    unzip \
    git \
    curl \
    libicu-dev \
    libzip-dev \
    libonig-dev

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip mysqli

# Get Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory in the container
WORKDIR /var/www/html

RUN a2enmod rewrite

# Copy the application's code to the working directory
COPY . .

# After copying your project into the container
RUN chmod 777 /var/www/html/.env && \
    chmod 777 /var/www/html/app/Providers/RouteServiceProvider.php && \
    chmod 777 /var/www/html/storage && \ 
    chmod 777 /var/www/html/bootstrap/cache

# Install Composer dependencies
RUN composer install

# Change ownership of the storage and bootstrap cache directories
RUN chown www-data:www-data /var/www/html/.env /var/www/html/app/Providers/RouteServiceProvider.php
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chown -R www-data:www-data /var/www/html/public

# Expose port 80 to the Docker host, so we can access it from the outside.
EXPOSE 80

# The following command runs Apache in the foreground, so the container doesn't stop.
CMD ["apache2-foreground"]
