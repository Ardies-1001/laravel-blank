# FROM richarvey/nginx-php-fpm:1.7.2

# COPY . .

# # Image config
# ENV SKIP_COMPOSER 1
# ENV WEBROOT /var/www/html/public
# ENV PHP_ERRORS_STDERR 1
# ENV RUN_SCRIPTS 1
# ENV REAL_IP_HEADER 1

# # Laravel config
# ENV APP_ENV production
# ENV APP_DEBUG false
# ENV LOG_CHANNEL stderr

# # Allow composer to run as root
# ENV COMPOSER_ALLOW_SUPERUSER 1

# CMD ["/start.sh"]


FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    nginx supervisor zip unzip git curl \
    libpng-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY . .

# Copier ta config Nginx & Supervisor
COPY conf/nginx/nginx-site.conf   /etc/nginx/sites-available/default
COPY conf/nginx/supervisord.conf   /etc/supervisor/conf.d/supervisord.conf

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
CMD ["/start.sh"]
