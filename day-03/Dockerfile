# Start with the official PHP image
FROM php:latest

WORKDIR /app
COPY ./src /app/src

COPY 03.txt /app/03.txt

CMD cd src && php main.php