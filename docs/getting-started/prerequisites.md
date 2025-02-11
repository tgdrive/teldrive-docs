# Prerequisites

Before you can start using this project, there are a few prerequisites you need to have in place. Please ensure that you have the following:

1. A Telegram account.
3. Private telegram channel for storing files.
4. A Supabase PostgreSQL database (skip if you want to use local postgres instance).
5. Docker and Docker compose(For Linux and Mac only).

## Docker Setup

```sh
curl https://get.docker.com | sh
```
**Verify Installation:**
```sh
docker --version
docker compose --version
```

## Creating a Supabase PostgreSQL Database

Supabase provides a hosted PostgreSQL database with an easy-to-use interface. Follow these steps to create a Supabase PostgreSQL database:

1. Go to the [Supabase website](https://supabase.io) and sign up for an account if you don't already have one.
2. Once logged in, click on the "New Project" button.
3. Fill out the project details:
- **Project Name**: Choose a name for your project.
- **Database Password**: Set a password for your database.
- **Region**: Select a region closest to you for better performance.
4. Click "Create New Project".
5. Once the project is created, you will be directed to the project dashboard. Here you can find your database connection details.Copy the connection string URI of `transaction` mode  which will be used later in teldrive config.
> [!IMPORTANT]
>- Make sure to enable pgroonga postgres extension in supabase.


## Creating a Local Posgtres Database using docker

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

**Change default user and password in environment variables.**

```sh
docker network create postgres
docker volume create postgres_data
docker compose up -d
```
- Connection string for local db will be `postgres://teldrive:secret@postgres/postgres` which will be used later in teldrive config.