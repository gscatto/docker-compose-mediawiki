FROM php:8.3.1-fpm-bookworm
# Install https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
# Install PHP extensions
RUN install-php-extensions apcu intl
