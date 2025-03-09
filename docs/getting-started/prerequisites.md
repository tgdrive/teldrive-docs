# Prerequisites

Before setting up Teldrive, ensure you have the following requirements in place:

## Required Components

1. **A Telegram Account**: You'll need an active Telegram account
2. **A Private Telegram Channel**: For storing your files securely
3. **A PostgreSQL Database**: Either Supabase (cloud-hosted) or a local instance
4. **Docker and Docker Compose**: For containerized deployment (required for Linux and macOS)

## Docker Installation

Install Docker and Docker Compose using the official Docker script:

```sh
curl https://get.docker.com | sh
```

Verify your installation:
```sh
docker --version
docker compose --version
```

## Database Options

You can use either Supabase (cloud-hosted) or set up a local PostgreSQL instance.

### Option 1: Using Supabase (Recommended for Beginners)

1. Go to [Supabase](https://supabase.io) and create an account
2. Click "New Project" and fill in the details:
   - **Project Name**: Give your project a name
   - **Database Password**: Set a secure password
   - **Region**: Choose the closest region to your location
3. Click "Create New Project"
4. Once created, go to the project dashboard
5. Find and copy the "Connection String (Transaction)" from the settings
6. **Important**: Enable the pgroonga extension in your Supabase project

### Option 2: Setting Up a Local PostgreSQL Database

Create a `docker-compose.yml` file with the following content:

::: code-group

```yml [docker-compose.yml]
services:
  postgres:
    image: groonga/pgroonga:latest-alpine-17
    container_name: postgres_db
    restart: always
    networks:
     - postgres
    environment:
      - POSTGRES_USER=teldrive
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data

networks:
  postgres:                                 
    external: true

volumes:
  postgres_data:
    external: true
```
:::

**Important**: Customize the username and password for security.

Launch your local database:

```sh
docker network create postgres
docker volume create postgres_data
docker compose up -d
```

Your local database connection string will be `postgres://teldrive:secret@postgres/postgres` (adjust username and password if changed).

## Next Steps

Once you have all prerequisites in place, proceed to the [Installation](/docs/getting-started/installation.md) or [Usage](/docs/getting-started/usage.md) guides.
