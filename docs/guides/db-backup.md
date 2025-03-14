# Automated Database Backups with Rclone

This guide explains how to set up automated backups of your Teldrive database to any storage provider supported by Rclone.

## Prerequisites

- A configured database from the [prerequisites guide](/docs/getting-started/prerequisites.md)
- A cloud storage account with any provider supported by Rclone
- Rclone configured with access to your desired cloud storage

## Setting Up Automated Backups

Create a Docker Compose file for the backup service:

::: code-group

```yml [docker-compose.yml]
services:
  rclone-backup:
    image: teldrive/rclone-backup # for postgres 16 use ghcr.io/adrienpoupa/rclone-backup
    container_name: rclone-backup
    environment:
      - RCLONE_REMOTE_NAME=remote # use your configured rclone remote name
      - BACKUP_KEEP_DAYS=10 # how many days to keep backup history
      - CRON=0 */6 * * * # backup frequency (every 6 hours in this example)
      - ZIP_ENABLE=true # enable backup compression
      - PG_HOST=postgres # database hostname
      - PG_DBNAME=postgres # database name
      - PG_USERNAME=user # database username
      - PG_PASSWORD=pass # database password
      - ZIP_PASSWORD=zippass # password to protect backup archives
    restart: always
    networks:
     - postgres
    volumes:
      - /path/to/rclone/configdir/:/app/rclone # mount your rclone config directory

networks:
  postgres:                                 
    external: true
```
:::

> [!NOTE]
> If you're using Supabase, remove the networks block from the compose file and update the database connection details accordingly.

Start the backup service:

```sh
docker compose up -d
```

## Configuration Options

Customize your backup solution further with these environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `RCLONE_REMOTE_NAME` | Name of your Rclone remote | *required* |
| `BACKUP_KEEP_DAYS` | Days to keep backup history | 7 |
| `CRON` | Backup schedule in cron format | "0 0 * * *" (daily) |
| `ZIP_ENABLE` | Enable backup compression | false |
| `ZIP_PASSWORD` | Password for encrypted backups | *empty* |
| `PG_HOST` | PostgreSQL host | *required* |
| `PG_DBNAME` | PostgreSQL database name | *required* |
| `PG_USERNAME` | PostgreSQL username | *required* |
| `PG_PASSWORD` | PostgreSQL password | *required* |

## Verifying Backups

Your backups will be uploaded to your configured Rclone remote according to the schedule. You can verify the backups by:

1. Checking the backup service logs: `docker logs rclone-backup`
2. Listing your backups in the remote storage: `rclone ls remote:path/to/backups`

## Restoring from Backup

If you need to restore from a backup, you have two options depending on the backup format:


1. Download the latest backup file from your remote storage
2. If compressed, extract the backup file
3. Restore using pg_restore:
   ```bash
   pg_restore --dbname="your_postgres_url" --create --no-owner --disable-triggers backup_file.dump
   ```
4. Optional: Add more pg_restore flags as needed:
   ```bash
   # Common additional options:
   # --jobs=N: Use N parallel jobs for restoration (speeds up process)
   # --schema=SCHEMA: Restore only objects in this schema
   # --data-only: Restore only data, not schema
   # --schema-only: Restore only schema, not data
   ```

### Docker Container Method

If you're running PostgreSQL in a Docker container:

```bash
# Copy the backup file into the container
docker cp backup_file.dump postgres_container:/tmp/

docker exec -it postgres_container pg_restore --dbname="your_postgres_url" --create --no-owner --disable-triggers /tmp/backup_file.dump
```
