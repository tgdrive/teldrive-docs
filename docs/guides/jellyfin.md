# Using Teldrive with Plex/Jellyfin/Emby

**This guide outlines the best practices for using Teldrive Plex/Jellyfin/Emby.**

**Read Teldrive setup guide before running this.**

### Install Docker Volume Plugin
```bash
docker plugin install ghcr.io/tgdrive/docker-volume-rclone --alias rclone --grant-all-permissions args="--allow-other" config=/etc/rclone cache=/var/cache
```
> [!NOTE] 
If you are using diff architecture, you can find all plugin tags [here](https://github.com/tgdrive/rclone/pkgs/container/docker-volume-rclone).Change rclone cache and config dir path acordingly

### Setting Up Jellyfin

::: code-group

```yml [docker-compose.yml]
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    volumes:
      - /path/to/config:/config
      - /path/to/cache:/cache
      - rclone:/media

volumes:
  rclone:
    external: true
```
:::

- Plex and Emby can be configured in a similar way.You can share teldrive volume to any container by using rclone volume driver.

> [!IMPORTANT]
>- Don't use restart policy in compose file that uses rclone volume driver.You have to use crontab job for containers that that depends on rclone volume.
>- Add the following script to crontab at startup.Change container name accodingly.

```bash
#!/bin/bash
set -e

is_container_running() {
  local container_name=$1
  docker inspect -f '{{.State.Running}}' $container_name 2>/dev/null || echo "false"
}

POLL_INTERVAL=2

CONTAINERS=("teldrive")

for container in "${CONTAINERS[@]}"; do
  while [ "$(is_container_running $container)" != "true" ]; do
    echo "Waiting for container $container to be running..."
    sleep $POLL_INTERVAL
  done
  echo "Container $container is running."
done

VOLUME_NAME="rclone"

VOLUME_EXISTS=$(docker volume inspect $VOLUME_NAME > /dev/null 2>&1 && echo "yes" || echo "no")

# Create the volume if it does not exist
if [ "$VOLUME_EXISTS" == "no" ]; then
  echo "Volume $VOLUME_NAME does not exist. Creating volume..."
  docker volume create \
    --driver rclone \
    --opt remote="teldrive_remote_name:" \
    --opt vfs_cache_max_age=7720h \
    --opt vfs_read_chunk_streams=2 \
    --opt vfs_read_chunk_size=64M \
    --opt vfs_cache_max_size=300G \
    $VOLUME_NAME
  echo "Volume $VOLUME_NAME created successfully."
else
  echo "Volume $VOLUME_NAME already exists. Skipping creation."
fi

# Add other services here which depends on rclone volume
cd /path/to/jellyfin/compose && docker compose up -d
```