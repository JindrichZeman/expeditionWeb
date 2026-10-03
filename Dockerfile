FROM php:8.2-fpm

# Instalace nezbytných rozšíření
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

EXPOSE 9000
CMD ["php-fpm"]
