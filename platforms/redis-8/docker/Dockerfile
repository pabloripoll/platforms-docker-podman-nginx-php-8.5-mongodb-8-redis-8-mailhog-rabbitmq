FROM redis:8.6-rc1-alpine3.23

# Install su-exec for privilege dropping
RUN apk add --no-cache su-exec

# Create log directory
RUN mkdir -p /etc/redis /var/log/redis && \
    chown -R redis:redis /var/log/redis

# Copy Redis configuration
COPY config/conf.d/redis.conf /usr/local/etc/redis/redis.conf

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /data

EXPOSE 6379

ENTRYPOINT ["docker-entrypoint.sh"]
CMD []