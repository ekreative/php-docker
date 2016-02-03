FROM php:5-cli

MAINTAINER Fred Cox "mcfedr@gmail.com"

RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
        libicu-dev \
        libxslt-dev \
        zlib1g-dev \
        curl \
        git

RUN docker-php-ext-install mcrypt intl mbstring pdo_mysql pcntl xsl zip

RUN touch /usr/local/etc/php/conf.d/pecl.ini \
    && pear config-set php_ini /usr/local/etc/php/conf.d/pecl.ini \
    && pecl config-set php_ini /usr/local/etc/php/conf.d/pecl.ini \
    && pecl install -o -f redis xdebug apcu-4.0.10 \
    && rm -rf /tmp/pear \
    && sed -i.bak '/^extension="xdebug.so"$/d' /usr/local/etc/php/conf.d/pecl.ini \
    && sed -i.bak '/^zend_extension="redis.so"$/d' /usr/local/etc/php/conf.d/pecl.ini

RUN echo "date.timezone=UTC" > /usr/local/etc/php/conf.d/timezone.ini
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory.ini

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
