#!/bin/sh
set -e

# Substitute PORT and BACKEND_URL into NGINX config at container start
envsubst '${PORT} ${BACKEND_URL}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Create runtime config file for frontend
cat <<EOF > /usr/share/nginx/html/runtime-config.js
window.RUNTIME_CONFIG = {
  BACKEND_URL: '${BACKEND_URL:-http://localhost:8080}',
  API_VERSION: '${API_VERSION:-v1}',
  ENVIRONMENT: '${ENVIRONMENT:-production}'
};
EOF

echo "Runtime configuration created"

exec "$@"
