# Use Nginx to serve the static content
FROM nginx:alpine

# Clean the default public folder
RUN rm -rf /usr/share/nginx/html/*

# Copy your pre-built dist folder content into Nginx
COPY dist/ /usr/share/nginx/html/

# Expose port 80 to match your K8s service
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
