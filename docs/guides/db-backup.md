# Backing Up Database through Rclone Remote

Make sure to setup database from [Prerequisites](/docs/getting-started/prerequisites.md) guide.

```yml
# docker-compose.yml
services:
  rclone-backup:
    image: ghcr.io/bhunter234/rclone-backup # for postgres 16 use ghcr.io/adrienpoupa/rclone-backup
    container_name: rclone-backup
    environment:
      - RCLONE_REMOTE_NAME=remote # use any rclone remote to backup db file
      - BACKUP_KEEP_DAYS=10
      - CRON=0 */6 * * * # backup file every 6 hours
      - ZIP_ENABLE=true
      - DB_TYPE=postgresql
      - PG_HOST=postgres
      - PG_DBNAME=postgres
      - PG_USERNAME=user
      - PG_PASSWORD=pass
      - ZIP_PASSWORD=zippass
    restart: always
    networks:
     - postgres
    volumes:
      - /path/to/rclone/configdir/:/config/rclone

networks:
  postgres:                                 
    external: true
```
Remove networks block in compose file if you are using supabase.

```sh
docker compose up -d
```