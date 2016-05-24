FROM php:7-cli

MAINTAINER Fred Cox "mcfedr@gmail.com"

RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
        libicu-dev \
        libxslt-dev \
        zlib1g-dev \
        libmemcached-dev \
        curl \
        git \
   && apt-get autoremove -y \
   && apt-get clean all

RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install intl
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install xsl
RUN docker-php-ext-install zip

ENV PHP_REDIS_VERSION php7
RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/${PHP_REDIS_VERSION}.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-${PHP_REDIS_VERSION} /usr/src/php/ext/redis
RUN docker-php-ext-install redis

ENV PHP_MEMCACHED_VERSION php7
RUN curl -L -o /tmp/memcached.tar.gz https://github.com/php-memcached-dev/php-memcached/archive/${PHP_MEMCACHED_VERSION}.tar.gz \
    && tar xfz /tmp/memcached.tar.gz \
    && rm -r /tmp/memcached.tar.gz \
    && mv php-memcached-${PHP_MEMCACHED_VERSION} /usr/src/php/ext/memcached
RUN docker-php-ext-install memcached

RUN pecl install -o -f xdebug \
    && rm -rf /tmp/pear
RUN docker-php-ext-enable xdebug

RUN pecl config-set preferred_state beta
    && pecl install -o -f apcu_bc \
    && rm -rf /tmp/pear
RUN docker-php-ext-enable --ini-name 0-apc.ini apcu apc

RUN echo "date.timezone=UTC" > /usr/local/etc/php/conf.d/timezone.ini
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory.ini

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace