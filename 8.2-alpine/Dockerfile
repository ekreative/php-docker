FROM php:8.2-cli-alpine

##<alpine>##
# hadolint ignore=DL3018
RUN apk --no-cache add \
        curl \
        git \
# For composer
        unzip
##</alpine>##

# https://github.com/mlocati/docker-php-extension-installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions apcu \
        bcmath \
        gd \
        grpc \
        imagick  \
        intl  \
        memcached \
        mongodb \
        opcache \
##<opencensus>##
        opencensus \
##</opencensus>##
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        protobuf \
        redis \
        soap \
        sockets \
        xsl \
        zip \
    && IPE_DONT_ENABLE=1 install-php-extensions xdebug

RUN echo "date.timezone=UTC" > /usr/local/etc/php/conf.d/timezone.ini \
    && echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory.ini

ENV COMPOSER_ALLOW_SUPERUSER=1
ADD https://getcomposer.org/composer-stable.phar /usr/local/bin/composer
RUN chmod +rx /usr/local/bin/composer \
    && composer global config --no-plugins allow-plugins.symfony/flex true \
    && composer global require symfony/flex \
    && rm -rf /home/composer/.composer/cache


RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
