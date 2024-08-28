# Use the official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies and enable PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install PHP dependencies with Composer
RUN composer install --no-dev --optimize-autoloader

# Set the correct permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 and run Apache in the foreground
EXPOSE 80
CMD ["apache2-foreground"]
