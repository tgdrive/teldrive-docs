# Deploying Teldrive with Cloudflare and Caddy using Docker Compose

This guide will walk you through deploying your application using Docker Compose for orchestration, alongside Cloudflare for DNS, CDN, and DDoS protection, and Caddy as a reverse proxy. This stack provides a robust, scalable, and easy-to-manage environment for your application.

## Prerequisites

Before you start, you'll need the following:

*   **A Domain Name:** You own a domain name that you can manage with Cloudflare.
*   **A Cloudflare Account:** Sign up for a free account at [Cloudflare](https://www.cloudflare.com/).
*   **A Server (VPS/Cloud Instance):** You have a server where you will run Docker and your application containers.
    *   Make sure your server has a public IP address.
    *   We recommend a Linux based server (Ubuntu or Debian).
*   **SSH Access:** You have SSH access to your server.
*   **Docker and Docker Compose:**  Installed on your server.
*   **Basic Terminal/Command Line Knowledge:** You are comfortable using a terminal and running commands.

## Cloudflare Setup

### Adding Your Domain to Cloudflare

- **Log in to Cloudflare:** Go to [Cloudflare](https://www.cloudflare.com/) and log in to your account.
- **Add a Site:** Click the "Add a Site" button and enter your domain name.
- **Select a Plan:** Choose the free plan to get started.
- **Review DNS Records:** Cloudflare will scan for existing DNS records. Review these and ensure they look correct.
- **Update Nameservers:** Cloudflare will provide you with nameservers to update with your domain registrar. Update these through your registrar's dashboard.

### Configuring DNS Records

- **Access your Cloudflare Dashboard:** After your domain is active, go to the DNS tab.
- **Add an `A` Record:**
    *   **Type:** `A`
    *   **Name:** `@` (or your subdomain, e.g., `www`)
    *   **IPv4 address:** Your server's public IP address.
    *   **Proxy Status:** Set to "Proxied" (orange cloud) to enable Cloudflare CDN and protection.
- **Add a `AAAA` Record (Optional):**
    *   If your server has an IPv6 address, add an `AAAA` record following the same steps as above using your servers IPv6.
- **Add an A record for wildcard domains (Optional):**
   *  **Type:** `A`
   * **Name:** `*`
   * **IPv4 address:** Your server's public IP address.
   * **Proxy Status:** Set to "Proxied"

### Recommended Cloudflare Settings

- **SSL/TLS Tab:**
    *   **Encryption Mode:** Ensure this is set to "Full" or "Full (strict)" to allow for end-to-end encryption.
    * **Always Use HTTPS:** Enable this option to redirect all `http` to `https`.
    * **Minimum TLS version:** Set this to 1.2.
- **Speed Tab:**
    *   **Auto Minify:** Enable all three for `HTML`, `CSS` and `JS`.
    *   **Brotli:** Enable this for better compression.
- **Security Tab:**
    *  **Web Application Firewall (WAF):** Set to "On" for basic security. Customize rules as needed.
    *  **Bot Fight Mode:** Enable this to block malicious bots.

## Docker and Docker Compose Setup

```sh
curl https://get.docker.com | sh
```
**Verify Installation:**
```sh
docker --version
docker-compose --version
```

## Deploy Services

```sh
docker network create caddy
```
**Place all yml files that you will create below in one directory**.

#### Deploy Teldrive

- Make sure you have followed [Usage](/docs/getting-started/usage.md) guide for setting up `config.toml`.

```yml
#teldrive.yml
services:
  teldrive:
    image: ghcr.io/tgdrive/teldrive
    restart: always
    container_name: teldrive
    networks:
     - postgres
     - caddy
    volumes:
      - ./config.toml:/config.toml
      - ./session.db:/session.db
networks:
  postgres:                                 
    external: true
  caddy:
    external: true
```

```sh
touch session.db
docker compose -f teldrive.yml  up -d
```
- Remove postgres part from if you are using supabase.

#### Deploy Imgproxy

```yml
#imgproxy.yml
services:
  imgproxy:
    image: darthsim/imgproxy
    container_name: imgproxy
    networks:
     - caddy
    environment:
      IMGPROXY_ALLOW_ORIGIN: "*"
      IMGPROXY_ENFORCE_WEBP: true
      IMGPROXY_MALLOC: "jemalloc"
    restart: always

networks:
  caddy:
    external: true
```

```sh
docker compose -f imgproxy.yml  up -d
```

## Caddy Setup with Docker

### Creating a Caddyfile

Create a `Caddyfile` in same directory to configure Caddy's reverse proxy:

```caddy

teldrive.yourdomain.com {
    tls internal
    reverse_proxy teldrive:8080
}

imgproxy.yourdomain.com {
    tls internal
    reverse_proxy imgproxy:8080
}
```
* `tls internal` is needed for cloudflare.
* Replace `yourdomain.com` with your domain.

```yml
#caddy.yml
services:
 caddy:
    image: caddy
    container_name: caddy
    ports:
     - "80:80"
     - "443:443"
     - "443:443/udp"
    networks:
      - caddy
    restart: always
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - ./caddy_data:/data

networks:
  caddy:                                 
    external: true 
```

### Running Caddy Service

- **Run Docker Compose:**
    ```sh
    docker-compose -f caddy.yml up -d
    ```
- Now teldrive should be accessible via your domain name `https://teldrive.yourdomain.com`.
- Change Resizer host to `https://imgproxy.yourdomain.com` in teldrive UI settings.


## Troubleshooting

*   **DNS Propagation:** Ensure your domain is pointing to your server's IP address.
*   **Teldrive Errors:** Check `docker logs teldrive -f ` for issues.
*   **Caddy Errors:** Use  `docker logs caddy -f` to view Caddy logs.
*   **Firewall:** Ensure the necessary ports (80 and 443) are open if you have a firewall enabled on your server.
*   **Cloudflare:** Double-check Cloudflare settings if you are facing issues.