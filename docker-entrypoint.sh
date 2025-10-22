#!/bin/sh
set -e

# Render nginx.conf from template, substituting PORT and BACKEND_URL
envsubst '${PORT} ${BACKEND_URL}' \
  < /etc/nginx/conf.d/default.conf.template \
  > /etc/nginx/conf.d/default.conf

# Create runtime-config.js for frontend to read at runtime
cat <<EOF > /usr/share/nginx/html/runtime-config.js
window.RUNTIME_CONFIG = {
  BACKEND_URL: '${BACKEND_URL:-http://localhost:8080}',
  API_VERSION: '${API_VERSION:-v1}',
  ENVIRONMENT: '${ENVIRONMENT:-production}'
};
EOF

echo "Runtime configuration created"

exec "$@"
