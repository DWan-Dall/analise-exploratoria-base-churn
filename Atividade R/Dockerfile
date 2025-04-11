FROM php:8.4-fpm

#Cria as parsta e concede permisão para salvar arquivos
RUN mkdir -p /var/www/html/graficos /var/www/html/scripts \
    && chown -R www-data:www-data /var/www/html/graficos /var/www/html/scripts

#Verifica se o Xdebug já está instalado
RUN if ! php -m | grep -q 'xdebug'; then \
    pecl install xdebug && \
    docker-php-ext-enable xdebug \
;fi

# Instala Python, R e pacotes que precisar
RUN apt-get update && apt-get install -y \
    python3 python3-pip r-base \
    && apt-get clean

# Instala pacotes específicos
RUN pip3 install pandas matplotlib seaborn

# Ativar shell_exec (se estiver desabilitado)
RUN echo "shell_exec is allowed"

# Instala extensões do PHP conforme necessário
RUN docker-php-ext-install pdo pdo_sql

COPY ./config/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini