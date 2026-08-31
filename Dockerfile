# Use the official pre-built Pterodactyl Panel image
FROM ghcr.io/pterodactyl/panel:latest

# Expose Render's default expected port
EXPOSE 10000

# Override the default environment port setting to map with Render
ENV APP_PORT=10000
ENV PORT=10000
