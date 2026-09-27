#!/bin/sh
set -e

echo "Starting Redis initialization..."

# Run as root initially to create files
if [ "$(id -u)" = "0" ]; then
    # Remove users.acl if it's a directory
    if [ -d /data/users.acl ]; then
        echo "/data/users.acl is a directory, removing it..."
        rm -rf /data/users.acl
    fi

    # Generate ACL file
    if [ ! -f /data/users.acl ]; then
        echo "Generating Redis ACL file..."
        cat > /data/users.acl <<EOF
user default off
user ${REDIS_ROOT_USER:-root} on >${REDIS_ROOT_PASSWORD:-changeme} ~* &* +@all
user ${REDIS_USER:-app} on >${REDIS_PASSWORD:-changeme} ~* &* +@all -@dangerous -@admin
EOF
        chown redis:redis /data/users.acl
        chmod 640 /data/users.acl
        echo "Redis ACL file created"
    fi

    # Fix ownership of /data directory
    chown -R redis:redis /data

    # Re-execute this script as redis user
    exec su-exec redis "$0" "$@"
fi

# Now running as redis user
echo "Running as user: $(id -un)"

# Start Redis with config file
if [ -f /usr/local/etc/redis/redis.conf ]; then
    echo "Starting Redis with redis.conf..."
    exec redis-server /usr/local/etc/redis/redis.conf "$@"
else
    echo "redis.conf not found, using defaults..."
    exec redis-server \
        --aclfile /data/users.acl \
        --appendonly yes \
        --bind 0.0.0.0 \
        --dir /data \
        --save "" \
        "$@"
fi