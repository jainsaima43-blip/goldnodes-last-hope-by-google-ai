# Use the official pre-built Pterodactyl Panel image
FROM ghcr.io/pterodactyl/panel:latest

# Expose Render's default expected port
EXPOSE 10000

# Force environment overrides directly inside the image
ENV APP_PORT=10000
ENV PORT=10000
