FROM php:7-cli

MAINTAINER Fred Cox "mcfedr@gmail.com"

RUN apt-get update && apt-get install -y \
        libmcrypt-dev \
        libicu-dev \
        libxslt-dev \
        zlib1g-dev \
        libmemcached-dev \
				libssl-dev \
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

RUN pecl install -o -f redis \
    && rm -rf /tmp/pear
RUN docker-php-ext-enable redis

ENV PHP_MEMCACHED_VERSION php7
RUN curl -L -o /tmp/memcached.tar.gz https://github.com/php-memcached-dev/php-memcached/archive/${PHP_MEMCACHED_VERSION}.tar.gz \
    && mkdir -p memcached \
    && tar xfz /tmp/memcached.tar.gz -C memcached --strip-components=1 \
    && rm -r /tmp/memcached.tar.gz \
    && ( \
      cd memcached \
      && phpize \
      && ./configure --enable-memcached \
      && make -j$(nproc) \
      && make install \
    ) \
    && rm -r memcached \
    && docker-php-ext-enable memcached

RUN pecl install -o -f xdebug mongodb \
    && rm -rf /tmp/pear
RUN docker-php-ext-enable xdebug
RUN docker-php-ext-enable mongodb

RUN pecl config-set preferred_state beta \
    && pecl install -o -f apcu_bc \
    && rm -rf /tmp/pear
RUN docker-php-ext-enable --ini-name 0-apc.ini apcu apc

ENV PHP_TIMECOP_VERSION master
RUN curl -L -o /tmp/timecop.tar.gz https://github.com/hnw/php-timecop/archive/${PHP_TIMECOP_VERSION}.tar.gz \
    && mkdir -p timecop \
    && tar xfz /tmp/timecop.tar.gz -C timecop --strip-components=1 \
    && rm -r /tmp/timecop.tar.gz \
    && ( \
      cd timecop \
      && phpize \
      && ./configure \
      && make -j$(nproc) \
      && make install \
    ) \
    && rm -r timecop \
    && docker-php-ext-enable timecop

RUN echo "date.timezone=UTC" > /usr/local/etc/php/conf.d/timezone.ini
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory.ini

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
