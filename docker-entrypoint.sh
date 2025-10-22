#!/bin/sh
set -e

echo "Starting entrypoint script..."

# Set defaults if env vars not provided
export PORT=${PORT:-8080}
export BACKEND_URL=${BACKEND_URL:-http://localhost:8080}

echo "PORT: $PORT"
echo "BACKEND_URL: $BACKEND_URL"

# Check if template exists
if [ ! -f /etc/nginx/conf.d/default.conf.template ]; then
    echo "ERROR: nginx.conf.template not found!"
    exit 1
fi

# Substitute environment variables into NGINX config
envsubst '${PORT},${BACKEND_URL}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Verify the config was created
if [ ! -f /etc/nginx/conf.d/default.conf ]; then
    echo "ERROR: Failed to create nginx config!"
    exit 1
fi

echo "NGINX config created successfully"
cat /etc/nginx/conf.d/default.conf

# Create runtime config file for frontend
cat <<EOF > /usr/share/nginx/html/runtime-config.js
window.RUNTIME_CONFIG = {
  BACKEND_URL: '${BACKEND_URL}',
  API_VERSION: '${API_VERSION:-v1}',
  ENVIRONMENT: '${ENVIRONMENT:-production}'
};
EOF

echo "Runtime configuration created"

# Start NGINX
exec "$@"
