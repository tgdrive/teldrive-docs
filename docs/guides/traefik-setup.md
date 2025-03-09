# Deploying Teldrive with Traefik

This guide shows how to deploy Teldrive with Traefik as a reverse proxy with automatic SSL and WebSocket support.

## Prerequisites

- A server with Docker and Docker Compose installed
- A domain pointing to your server

## Setting Up Traefik

### Create Network & Files

```bash
docker network create traefik-public
mkdir -p traefik
cd traefik
touch acme.json
chmod 600 acme.json
touch traefik.yml
```

### Basic Traefik Configuration

Add to `traefik.yml`:

```yaml
# Global configuration
global:
  checkNewVersion: true
  sendAnonymousUsage: false

# Entry points configuration
entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure
          scheme: https
  websecure:
    address: ":443"

# Let's Encrypt configuration
certificatesResolvers:
  letsencrypt:
    acme:
      email: your-email@example.com  # Replace with your email
      storage: acme.json
      tlsChallenge: {}

# Providers configuration
providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
    network: traefik-public

# API and dashboard configuration
api:
  dashboard: true
```

### Traefik Docker Compose

Create `docker-compose.yml`:

```yml
services:
  traefik:
    image: traefik:v2.10
    container_name: traefik
    restart: always
    security_opt:
      - no-new-privileges:true
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./traefik.yml:/etc/traefik/traefik.yml:ro
      - ./acme.json:/acme.json
    networks:
      - traefik-public
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.traefik.rule=Host(`traefik.yourdomain.com`)"  # Replace with your domain
      - "traefik.http.routers.traefik.service=api@internal"
      - "traefik.http.routers.traefik.entrypoints=websecure"
      - "traefik.http.routers.traefik.tls.certresolver=letsencrypt"
      # Secure the dashboard
      - "traefik.http.middlewares.traefik-auth.basicauth.users=admin:$$apr1$$JkpAEfK1$$N9iAcaUrQMXJJnKjMPO/00"  # Generate your own password
      - "traefik.http.routers.traefik.middlewares=traefik-auth"
      # Security headers
      - "traefik.http.middlewares.secure-headers.headers.sslRedirect=true"
      - "traefik.http.middlewares.secure-headers.headers.stsSeconds=31536000"

networks:
  traefik-public:
    external: true
```

Launch Traefik:

```bash
docker compose up -d
```

## Deploying Teldrive

Create a new directory and `docker-compose.yml`:

```yml
services:
  teldrive:
    image: ghcr.io/tgdrive/teldrive
    container_name: teldrive
    restart: unless-stopped
    volumes:
      - ./config.toml:/config.toml
      - ./storage.db:/storage.db
    networks:
      - traefik-public
      - postgres
    labels:
      - "traefik.enable=true"
      # HTTP Router
      - "traefik.http.routers.teldrive.rule=Host(`teldrive.yourdomain.com`)"  # Your domain here
      - "traefik.http.routers.teldrive.entrypoints=websecure"
      - "traefik.http.routers.teldrive.tls.certresolver=letsencrypt"
      - "traefik.http.services.teldrive.loadbalancer.server.port=8080"
      # Security headers
      - "traefik.http.routers.teldrive.middlewares=secure-headers"
      # WebSocket support (critical)
      - "traefik.http.middlewares.teldrive-ws.headers.customRequestHeaders.Connection=Upgrade"
      - "traefik.http.middlewares.teldrive-ws.headers.customRequestHeaders.Upgrade=websocket"
      - "traefik.http.routers.teldrive.middlewares=teldrive-ws,secure-headers"

  imgproxy:
    image: darthsim/imgproxy
    container_name: imgproxy
    restart: unless-stopped
    environment:
      IMGPROXY_ALLOW_ORIGIN: "*"
      IMGPROXY_ENFORCE_WEBP: true
      IMGPROXY_MALLOC: "jemalloc"
    networks:
      - traefik-public
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.imgproxy.rule=Host(`img.yourdomain.com`)"  # Your domain here
      - "traefik.http.routers.imgproxy.entrypoints=websecure"
      - "traefik.http.routers.imgproxy.tls.certresolver=letsencrypt"
      - "traefik.http.services.imgproxy.loadbalancer.server.port=8080"
      # Cache headers
      - "traefik.http.middlewares.imgproxy-cache.headers.customResponseHeaders.Cache-Control=public,max-age=604800"
      - "traefik.http.routers.imgproxy.middlewares=imgproxy-cache,secure-headers"

networks:
  traefik-public:
    external: true
  postgres:
    external: true
```

Start Teldrive:

```bash
touch storage.db
docker compose up -d
```

## Troubleshooting

**Certificate Issues:**
- Ensure domain DNS is properly configured
- Check that `acme.json` has 600 permissions
- View logs with `docker logs traefik`

**WebSocket Connection Failures:**
- Check browser console for connection errors
- Verify middleware configuration

**Container Networking Issues:**
- Ensure all services are on the `traefik-public` network
- Check container logs: `docker logs teldrive`

## Updating Services

```bash
# Update Traefik
docker compose pull
docker compose up -d

# Update Teldrive (in teldrive directory)
docker compose pull
docker compose up -d
```
