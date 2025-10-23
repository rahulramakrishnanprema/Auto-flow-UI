# Agentic_UI/Dockerfile
# Simple Nginx-based Dockerfile to serve React static build (dist/ folder)
# This serves your frontend as a static site on Cloud Run

FROM nginx:alpine

# Copy the built React app (dist folder) to Nginx's html directory
COPY dist /usr/share/nginx/html

# Expose port 80 (HTTP) for Cloud Run
EXPOSE 80

# Start Nginx in foreground mode (required for containers)
CMD ["nginx", "-g", "daemon off;"]