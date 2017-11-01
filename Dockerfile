FROM wyveo/nginx-php-fpm:latest

# Remove default webroot files & set PHP session handler to Redis
RUN rm -rf /usr/share/nginx/html/* && \
sed -i -e "s/memory_limit\s*=\s*.*/memory_limit = 256M/g" ${php_conf} && \
sed -i -e "s/session.save_handler\s*=\s*.*/session.save_handler = redis/g" ${php_conf} && \
sed -i -e "s/;session.save_path\s*=\s*.*/session.save_path = \"\${REDIS_PORT_6379_TCP}\"/g" ${php_conf}

# Add default craft cms nginx config
ADD ./default.conf /etc/nginx/conf.d/default.conf

# Copy local Craft
COPY ./craft /usr/share/nginx/craft
COPY ./html /usr/share/nginx/html

# Cleanup
RUN chown -Rf nginx:nginx /usr/share/nginx/

EXPOSE 80