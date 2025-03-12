# Using Teldrive with Media Servers (Plex/Jellyfin/Emby)

This guide explains how to integrate Teldrive with popular media server applications like Plex, Jellyfin, and Emby to create your own streaming media solution.

**Important:** Complete the Teldrive setup before following this guide.

## Install Docker Volume Plugin

First, install the rclone Docker volume plugin to mount your Teldrive storage:

```bash
docker plugin install teldrive/docker-volume-rclone --alias rclone --grant-all-permissions args="--allow-other" config=/etc/rclone cache=/var/cache
```

> [!NOTE]
> If you're using a different architecture, find all plugin tags [here](https://github.com/tgdrive/rclone/pkgs/container/docker-volume-rclone). Adjust the rclone cache and config directory paths accordingly.

## Setting Up Jellyfin

Create a Docker Compose file to run Jellyfin with access to your Teldrive storage:

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

Plex and Emby can be configured similarly. You can share the Teldrive volume with any container using the rclone volume driver.

## Important Container Management

> [!IMPORTANT]
> - Don't use restart policies in compose files that use the rclone volume driver.
> - Instead, use a crontab job for containers that depend on rclone volumes.
> - Add the following script to crontab to run at startup (modify container names as needed):

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

# Add other services here which depend on rclone volume
cd /path/to/jellyfin/compose && docker compose up -d
```
