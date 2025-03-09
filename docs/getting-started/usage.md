# Teldrive Usage Guide

This guide will help you set up and configure Teldrive. Make sure you've completed all prerequisites before proceeding.

## Configuration

Create a `config.toml` file with the appropriate settings for your environment. Below are examples for different database setups.

### Configuration for Supabase Database

```toml
[db]
data-source = "postgres://<db username>:<db password>@<db host>/<db name>"
prepare-stmt = false

[db.pool]
enable = false

[jwt]
allowed-users = ["your-telegram-username"]
secret = "your-jwt-secret-key"

[tg.uploads]
encryption-key = "your-encryption-key"
```

### Configuration for Local Database

```toml
[db]
data-source = "postgres://<db username>:<db password>@<db host>/<db name>"

[jwt]
allowed-users = ["your-telegram-username"]
secret = "your-jwt-secret-key"

[tg.uploads]
encryption-key = "your-encryption-key"
```

## Important Configuration Values 

- **data-source**: Connection string for your database (from Supabase or local instance)
- **allowed-users**: Your Telegram username(s) to restrict access (without the @ symbol)
- **secret**: Your JWT secret key for secure authentication
- **encryption-key**: Key for encrypting file data (optional but recommended)

> [!NOTE]  
> - For local database connection strings, refer to the [prerequisites guide](/docs/getting-started/prerequisites#creating-a-local-posgtres-instance-using-docker)
> - For advanced configuration options, see the [CLI reference](/docs/cli/run.md)
> - View a complete sample configuration at the [GitHub repository](https://github.com/tgdrive/teldrive/blob/main/config.sample.toml)

## Generating a JWT Secret

For the `secret` field, generate a secure random string:

- Using OpenSSL: `openssl rand -hex 32`
- Or visit: [Generate Secret](https://generate-secret.vercel.app/32)

## Running with Docker 

Create a `docker-compose.yml` file:

::: code-group

```yml [docker-compose.yml]
services:
  teldrive:
    image: ghcr.io/tgdrive/teldrive
    restart: always
    container_name: teldrive
    networks:
     - postgres
    volumes:
      - ./config.toml:/config.toml
      - ./storage.db:/storage.db
    ports:
      - 8080:8080
networks:
  postgres:                                 
    external: true
```
:::

Start Teldrive:
```sh
# Remove networks block from docker-compose.yml if using Supabase
touch storage.db
docker compose up -d
```

## Running Without Docker 

If you installed Teldrive directly:

```sh
./teldrive run
```

You can also place your config at `$HOME/.teldrive/config.toml` to run Teldrive from any location.

## Accessing Teldrive

1. Open http://localhost:8080 in your browser
2. Log in with your Telegram account
3. Sync your channels from UI Settings
4. Set a default channel in UI Settings

> [!NOTE]  
> - If you're stuck on the login screen, your system clock may be out of sync. Telegram requires accurate time synchronization to prevent dropped packets. See the [MTProto documentation](https://core.telegram.org/mtproto#time-synchronization) for details.
> - You can enable automatic time synchronization by setting `ntp = true` in your config's `[tg]` section or using the `--tg-ntp` CLI flag.
