# Stage 1: Build React app
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --silent
COPY . .
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Install envsubst for variable substitution
RUN apk add --no-cache gettext

# Remove default NGINX config and add template
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf.template /etc/nginx/conf.d/default.conf.template

# Copy built assets
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy and make entrypoint executable
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose the port Cloud Run expects
EXPOSE 8080

# Health check to wait for container startup
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/ || exit 1

# Use the entrypoint script to generate configs, then start NGINX
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
