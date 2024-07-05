# Utiliser l'image officielle de PHP 8.2 avec FPM
FROM php:8.2-fpm

# Installer les dépendances requises
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définir le répertoire de travail
WORKDIR /var/www/html

# Copier le reste des fichiers du projet Symfony
COPY . .

# Installer les dépendances Symfony
RUN composer install --no-scripts --no-interaction --no-plugins
