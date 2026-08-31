FROM alpine:latest

# Install dependencies
RUN apk add --no-cache curl bash mariadb mariadb-client nginx php82 php82-bcmath php82-cli php82-common php82-dom php82-fileinfo php82-fpm php82-gd php82-gmp php82-hash php82-json php82-mbstring php82-openssl php82-pdo php82-pdo_mysql php82-phar php82-redis php82-tokenizer php82-xml php82-xmlwriter php82-zip supervisor

# Download Pterodactyl Panel
RUN mkdir -p /var/www/pterodactyl && \
    cd /var/www/pterodactyl && \
    curl -Lo panel.tar.gz https://github.com && \
    tar -xzvf panel.tar.gz && \
    chmod -R 755 storage/* bootstrap/cache/

# Render and Koyeb use port 10000 or a dynamic $PORT environment variable
EXPOSE 10000

# Startup script to boot database and web server together
RUN echo '#!/bin/bash\n\
mysqld_safe --datadir=/var/lib/mysql --port=3306 &\n\
sleep 5\n\
mysql -e "CREATE DATABASE IF NOT EXISTS panel;"\n\
php /var/www/pterodactyl/artisan key:generate --force\n\
php /var/www/pterodactyl/artisan migrate --seed --force\n\
sed -i "s/listen = 127.0.0.1:9000/listen = 9000/g" /etc/php82/php-fpm.d/www.conf\n\
php-fpm82\n\
nginx -g "daemon off;"' > /start.sh && chmod +x /start.sh

CMD ["/start.sh"]
