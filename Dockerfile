FROM php:8.1-cli-alpine as php

# install nginx, supervisor and other libraries
RUN apk add --no-cache nginx \
    supervisor \
    git  \
    zip \
    libzip-dev \
    $PHPIZE_DEPS

# install needed php extensions
RUN docker-php-ext-install sockets pcntl zip

FROM php as swoole

# install openswoole
RUN pecl install openswoole

# enable openswoole
RUN docker-php-ext-enable openswoole

FROM swoole

# set working directory
WORKDIR /var/www/html

# copy configs
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.default.conf /etc/nginx/http.d/default.conf

# change directory access
RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx

# set user to nobody
USER nobody

# we will expose default http 80 port
EXPOSE 80

# run supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
