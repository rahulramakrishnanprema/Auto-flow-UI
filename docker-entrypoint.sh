#!/bin/sh
set -e

if [ ! -z "$BACKEND_URL" ]; then
    echo "Setting backend URL to: $BACKEND_URL"
    envsubst '${BACKEND_URL}' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf.tmp
    mv /etc/nginx/conf.d/default.conf.tmp /etc/nginx/conf.d/default.conf
fi

cat <<EOF > /usr/share/nginx/html/runtime-config.js
window.RUNTIME_CONFIG = {
  BACKEND_URL: '${BACKEND_URL:-http://localhost:8080}',
  API_VERSION: '${API_VERSION:-v1}',
  ENVIRONMENT: '${ENVIRONMENT:-production}'
};
EOF

echo "Runtime configuration created"

exec "$@"
