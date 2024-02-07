FROM php:8.3.1-fpm-bookworm
# Install https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
# Install PHP extensions
RUN install-php-extensions apcu calendar intl mysqli
# Install system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    imagemagick && \
    rm -rf /var/lib/apt/lists/*
ARG MEDIAWIKI_HOST
# Fix directory permissions for Nginx user
RUN mkdir -p /var/www/${MEDIAWIKI_HOST}/html/w/private && \
    mkdir -p /var/www/${MEDIAWIKI_HOST}/html/w/public && \
    chown -R 101:101 /var/www/${MEDIAWIKI_HOST}
