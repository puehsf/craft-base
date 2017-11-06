FROM germanramos/nginx-php-fpm:v7.0.7

RUN apk update && apk add php7.0-mbstring

# Remove default webroot files & set PHP session handler to Redis
RUN rm -rf /var/www/html/* && \
sed -i -e "s/memory_limit\s*=\s*.*/memory_limit = 256M/g" ${php_conf} && \
sed -i -e "s/session.save_handler\s*=\s*.*/session.save_handler = redis/g" ${php_conf} && \
sed -i -e "s/;session.save_path\s*=\s*.*/session.save_path = \"\${REDIS_PORT_6379_TCP}\"/g" ${php_conf}

# Add default craft cms nginx config
ADD ./default.conf /etc/nginx/conf.d/default.conf

# Copy local Craft and set owner (works rom Docker 17.09)
COPY --chown=nginx ./craft /var/www/craft
COPY --chown=nginx ./html /var/www/html

# Cleanup 
# RUN chown -Rf nginx:nginx /var/www/

# USER nginx
WORKDIR /var/www/	

# EXPOSE 80