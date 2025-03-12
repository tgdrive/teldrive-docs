# Deploying Teldrive with Cloudflare and Caddy

This guide walks you through deploying Teldrive with Cloudflare for DNS, CDN, and DDoS protection, and Caddy as a reverse proxy using Docker Compose. This setup provides robust, secure, and easy-to-manage hosting for your Teldrive instance.

## Prerequisites

Before you begin, ensure you have:

* **A Domain Name:** You own and control a domain name
* **A Cloudflare Account:** Free account at [Cloudflare](https://www.cloudflare.com/)
* **A Server:** VPS or cloud instance with public IP address (Linux recommended)
* **SSH Access:** Terminal access to your server
* **Docker and Docker Compose:** Installed on your server
* **Basic Command Line Knowledge:** Familiarity with terminal commands

## Cloudflare Setup

### Adding Your Domain to Cloudflare

1. **Log in to Cloudflare** and click "Add a Site"
2. **Enter your domain name** and select the free plan
3. **Review DNS Records** that Cloudflare finds automatically
4. **Update Nameservers** at your domain registrar with Cloudflare's provided nameservers

### Configuring DNS Records

In your Cloudflare dashboard:

1. **Add an `A` Record:**
   * **Type:** `A`
   * **Name:** `@` (or your subdomain like `www`)
   * **IPv4 address:** Your server's public IP address
   * **Proxy Status:** "Proxied" (orange cloud) to enable Cloudflare CDN

2. **Add a Wildcard Domain (Optional):**
   * **Type:** `A`
   * **Name:** `*`
   * **IPv4 address:** Your server's public IP address
   * **Proxy Status:** "Proxied"

3. **Add AAAA Records** if your server has IPv6 addresses (optional)

### Recommended Cloudflare Settings

* **SSL/TLS Settings:**
  * **Encryption Mode:** "Full" or "Full (strict)"
  * **Always Use HTTPS:** Enabled
  * **Minimum TLS version:** 1.2

* **Performance Settings:**
  * **Auto Minify:** Enable for HTML, CSS, and JS
  * **Brotli:** Enabled

* **Security Settings:**
  * **Web Application Firewall (WAF):** On
  * **Bot Fight Mode:** Enabled

## Docker Setup

If you haven't installed Docker yet:

```sh
curl https://get.docker.com | sh
```

Verify installation:
```sh
docker --version
docker compose --version
```

## Deploy Services

Ensure you've followed the [usage guide](/docs/getting-started/usage.md) for setting up `config.toml` and your database.

Create these files in the same directory, adjusting configurations as needed:

::: code-group

```yml [teldrive.yml]
services:
  teldrive:
    image: teldrive/teldrive
    restart: always
    container_name: teldrive
    networks:
     - postgres
     - caddy
    volumes:
      - ./config.toml:/config.toml
      - ./storage.db:/storage.db
networks:
  postgres:                                 
    external: true
  caddy:
    external: true
```

```yml [imgproxy.yml]
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
``` [Caddyfile]
teldrive.yourdomain.com {
    tls internal
    reverse_proxy teldrive:8080
}

imgproxy.yourdomain.com {
    tls internal
    reverse_proxy imgproxy:8080
}
```

```yml [caddy.yml]
services:
 caddy:
    image: teldrive/caddy
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
      - caddy_data:/data

networks:
  caddy:                                 
    external: true

volumes:
  caddy_data:
    external: true
```
:::

Set up and start the services:

```sh
touch storage.db
docker network create caddy
docker volume create caddy_data
docker compose -f teldrive.yml up -d
docker compose -f imgproxy.yml up -d
docker compose -f caddy.yml up -d
```

* Replace `yourdomain.com` with your actual domain in the Caddyfile
* Access Teldrive at `https://teldrive.yourdomain.com`
* Update the Resizer host to `https://imgproxy.yourdomain.com` in Teldrive UI settings

## Troubleshooting

* **DNS Issues:** Ensure your domain is pointing to your server's IP address
* **Teldrive Errors:** Check logs with `docker logs teldrive -f`
* **Caddy Errors:** Check logs with `docker logs caddy -f`
* **Firewall Issues:** Ensure ports 80 and 443 are open on your server
* **Cloudflare Configuration:** Double-check your Cloudflare settings if experiencing issues
