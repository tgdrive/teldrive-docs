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

[tg]
app-id = "your_telegram_app_id"
app-hash = "your_telegram_app_hash"
```
### `config.toml` for Local DB

```toml
[db]
data-source = "postgres://<db username>:<db password>@<db host>/<db name>"

[jwt]
allowed-users = ["your-telegram-username"]
secret = "abcd"

[tg]
app-id = "your_telegram_app_id"
app-hash = "your_telegram_app_hash"
```

## Values 
- app-id: Your Telegram application ID (obtained from my.telegram.org)
- app-hash: Your Telegram application hash (obtained from my.telegram.org)
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
```sh
curl -LO "https://raw.githubusercontent.com/tgdrive/teldrive/refs/heads/main/docker/compose/teldrive.yml"
# Remove networks block from teldrive.yml if you are using supabase
touch session.db
docker compose -f teldrive.yml  up -d
```
- Go to  http://localhost:8080 in your browser to access teldrive.
- Set default channel in UI settings.

## Run Without Docker 

```sh
./teldrive run
```
- You can also create config in `$HOME/.teldrive/config.toml` then you can run teldrive from everywhere.
- Go to  http://localhost:8080 in your browser to access teldrive.