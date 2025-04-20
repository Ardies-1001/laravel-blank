FROM php:8.2-fpm

# Installer dépendances système
RUN apt-get update && apt-get install -y \
    nginx \
    git \
    curl \
    zip \
    unzip \
    supervisor \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copier les fichiers de l'app
COPY . /var/www/html

# Définir le répertoire de travail
WORKDIR /var/www/html

COPY conf/nginx/nginx-site.conf /etc/nginx/sites-available/default
COPY conf/nginx/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Droits
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Exposer le port
EXPOSE 80

CMD ["/usr/bin/supervisord"]
