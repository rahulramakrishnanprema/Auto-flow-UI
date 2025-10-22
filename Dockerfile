# ---------- Stage 1: Builder ----------
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files and install all deps for build (including devDeps)
COPY package*.json ./
RUN npm ci --silent

# Copy source and run Vite build
COPY . .
RUN npm run build

# ---------- Stage 2: Production ----------
FROM nginx:alpine

# Remove default NGINX config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy static assets from builder’s dist folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy entrypoint script to inject runtime env
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose port 80
EXPOSE 80

# Health check on port 80
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:80/ || exit 1

# Entrypoint and default command
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
