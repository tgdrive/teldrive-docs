# Teldrive Usage Guide

This guide will help you set up and use Teldrive. Ensure you have met all the prerequisites and have the necessary configuration values ready.

## Configuration

Create a `config.toml` with the following content, replacing the placeholders with your actual values.

### `config.toml` for Supabase DB

```toml
[db]
data-source = "postgres://<db username>:<db password>@<db host>/<db name>"
prepare-stmt = false

[db.pool]
enable = false

[jwt]
allowed-users = ["your-telegram-username"]
secret = "abcd"

[tg.uploads]
encryption-key = "your-encryption-key"


```
### `config.toml` for Local DB

```toml
[db]
data-source = "postgres://<db username>:<db password>@<db host>/<db name>"

[jwt]
allowed-users = ["your-telegram-username"]
secret = "abcd"

[tg.uploads]
encryption-key = "your-encryption-key"

```

## Values 
- data-source: Connection string obtained from supabase or local db instance
- allowed-users: Make sure to add your telegram `username` here for restricting access to others users.

> [!NOTE]  
>- For local db use `data-source` from [prerequisites](/docs/getting-started/prerequisites#creating-a-local-posgtres-instance-using-docker) guide.
>- For advanced cli [usage](/docs/cli/run.md).
>- For Sample config [visit](https://github.com/tgdrive/teldrive/blob/main/config.sample.toml).

## Generating a JWT Secret
**For the secret field, use your generated JWT secret. You can generate one using:**
- OpenSSL: `openssl rand -hex 32`
- Or visit: [Generate Secret](https://generate-secret.vercel.app/32)

## Run With Docker 

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
```sh
# Remove networks block from teldrive.yml if you are using supabase
touch storage.db
docker compose up -d
```
- Go to  http://localhost:8080 in your browser to access teldrive.

## Run Without Docker 

```sh
./teldrive run
```
- You can also create config in `$HOME/.teldrive/config.toml` then you can run teldrive from everywhere.
- Go to  http://localhost:8080 in your browser to access teldrive.
- Sync channels from UI settings.
- Set default channel in UI settings.

> [!NOTE]  
>- If you are stuck on login screen you have to sync your system clock so that telegram doesn't drop all the packets.See more [here](https://core.telegram.org/mtproto#time-synchronization).
>- You can also use NTP(Network Time Protocol) to sync your system clock.To enable this in teldrive use `ntp` key in tg config section or pass `--tg-ntp` in cli.