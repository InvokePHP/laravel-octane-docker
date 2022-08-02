# Laravel Octane Docker

Laravel Octane + swoole + nginx docker image for production usage.

## Installation

```shell
docker pull kohutd/octane
```

## Usage

Folders structure:

```
laravel-application/ # source code of your laravel application
.dockerignore
Dockerfile
```

1. Create `Dockerfile`:

```dockerfile
# build vendor
FROM composer:2 as vendor
WORKDIR /app
COPY laravel-application /app
RUN composer install --no-interaction --optimize-autoloader --no-dev

# build application
FROM kohutd/octane
WORKDIR /var/www/html
# copy application source code
COPY --chown nobody laravel-application /var/www/html
# copy vendor
COPY --from=vendor --chown nobody /app/vendor /var/www/html/vendor
```

2. Build an image with your application:

```shell
docker build -t laravel-application-octane .
```

3. Run a container with your image:

```shell
export APP_KEY=someappkey

docker run -p 80:80 laravel-application-octane
```
