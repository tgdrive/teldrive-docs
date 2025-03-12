# Deploying Teldrive with Nginx Proxy

This guide shows how to deploy Teldrive with automatic SSL certificate generation using nginx-proxy and Let's Encrypt companion containers.

## Prerequisites

- A server with Docker and Docker Compose installed
- A domain or subdomain pointing to your server
- Port 80 and 443 accessible from the internet

## Setting Up Docker Networks

Create shared Docker networks for your containers:

```bash
docker network create nginx-proxy
```

## Setting Up Nginx Proxy Manager

First, create a `proxy.yml` file for the proxy setup:

```yml
version: '3'

services:
  nginx-proxy:
    image: nginxproxy/nginx-proxy
    container_name: nginx-proxy
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./nginx/certs:/etc/nginx/certs
      - ./nginx/vhost.d:/etc/nginx/vhost.d
      - ./nginx/html:/usr/share/nginx/html
      - ./nginx/conf.d:/etc/nginx/conf.d
    networks:
      - nginx-proxy
    labels:
      - "com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy=true"

  letsencrypt:
    image: nginxproxy/acme-companion
    container_name: nginx-proxy-letsencrypt
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./nginx/certs:/etc/nginx/certs
      - ./nginx/vhost.d:/etc/nginx/vhost.d
      - ./nginx/html:/usr/share/nginx/html
      - ./nginx/acme:/etc/acme.sh
    environment:
      - DEFAULT_EMAIL=your-email@example.com
    depends_on:
      - nginx-proxy
    networks:
      - nginx-proxy

networks:
  nginx-proxy:
    external: true
```

Create the necessary directories:

```bash
mkdir -p nginx/certs nginx/vhost.d nginx/html nginx/conf.d nginx/acme
```

Start the nginx-proxy containers:

```bash
docker compose -f proxy.yml up -d
```

## Docker Compose for Teldrive

Create a `docker-compose.yml` file for Teldrive setup:

```yml
version: '3'

services:
  teldrive:
    image: teldrive/teldrive
    container_name: teldrive
    restart: always
    volumes:
      - ./config.toml:/config.toml
      - ./storage.db:/storage.db
    environment:
      - VIRTUAL_HOST=teldrive.yourdomain.com
      - VIRTUAL_PORT=8080
      - LETSENCRYPT_HOST=teldrive.yourdomain.com
    networks:
      - nginx-proxy
      - postgres

  imgproxy:
    image: darthsim/imgproxy
    container_name: imgproxy
    restart: always
    environment:
      - IMGPROXY_ALLOW_ORIGIN=*
      - IMGPROXY_ENFORCE_WEBP=true
      - IMGPROXY_MALLOC=jemalloc
      - VIRTUAL_HOST=img.yourdomain.com
      - VIRTUAL_PORT=8080
      - LETSENCRYPT_HOST=img.yourdomain.com
    networks:
      - nginx-proxy

networks:
  nginx-proxy:
    external: true
  postgres:
    external: true
```

## Configure WebSocket Support

Create a custom configuration for WebSocket support:

```bash
cat > nginx/vhost.d/teldrive.yourdomain.com << 'EOL'
location / {
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_read_timeout 86400;
    client_max_body_size 2000M;
}
EOL
```

## Start Teldrive Services

Initialize and start the services:

```bash
touch storage.db  # Create the SQLite database file if it doesn't exist
docker compose up -d
```

## Important Configuration Notes

1. **Domain Configuration**: Replace `teldrive.yourdomain.com` and `img.yourdomain.com` with your actual domains in the Docker Compose files.

2. **Email for Certificates**: Update `DEFAULT_EMAIL=your-email@example.com` with your actual email address in the `proxy.yml` file.

3. **Teldrive Configuration**: Make sure you've created your `config.toml` file as described in the [usage guide](/docs/getting-started/usage.md).

4. **UI Settings**: After setting up the services, access the Teldrive UI at `https://teldrive.yourdomain.com` and set the image resizer URL to `https://img.yourdomain.com` in the settings page.

## Troubleshooting

**Certificate Issues:**
- Check that your domain's DNS is properly configured and pointing to your server's IP address
- Allow up to 5 minutes for certificate issuance
- Check logs with `docker logs nginx-proxy-letsencrypt`

**WebSocket Connection Failures:**
- Verify the custom vhost configuration file is in place
- Check browser console for connection errors
- Inspect logs with `docker logs nginx-proxy` and `docker logs teldrive`

**502 Bad Gateway Errors:**
- Confirm Teldrive is running: `docker ps`
- Check Teldrive logs: `docker logs teldrive`

## Updating Services

To update your services to the latest versions:

```bash
# Update proxy containers
docker compose -f proxy.yml pull
docker compose -f proxy.yml up -d

# Update Teldrive containers
docker compose pull
docker compose up -d
```
