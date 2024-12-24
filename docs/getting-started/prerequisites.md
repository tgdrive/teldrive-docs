# Prerequisites

Before you can start using this project, there are a few prerequisites you need to have in place. Please ensure that you have the following:

1. A Telegram account.
2. A Telegram application (to obtain `api_id` and `api_hash`).
3. A Supabase PostgreSQL database (skip if you want to use local postgres instance).
4. Docker and Docker compose(For Linux and Mac only).

## Install Docker

```sh
curl https://get.docker.com | sh
```

## Creating a Telegram Account

If you don't already have a Telegram account, you will need to create one. You can do this by downloading the Telegram app from the [App Store](https://apps.apple.com/us/app/telegram-messenger/id686449807) or [Google Play](https://play.google.com/store/apps/details?id=org.telegram.messenger&hl=en). Once installed, open the app and follow the instructions to create your account.

## Creating a Telegram Application

To interact with the Telegram API, you need to create a Telegram application and obtain the `api_id` and `api_hash`. Follow these steps to create a Telegram application:

1. Open your web browser and go to the [Telegram API development tools](https://my.telegram.org).
2. Log in using your phone number and the verification code sent to your Telegram app.
3. Once logged in, click on the "API Development Tools" link.
4. Fill out the form to create a new application:
   - **App title**: Choose a name for your application.
   - **Short name**: Choose a short name for your application.
   - **Platform**: Select the platform you are developing for (e.g., Web, Android, iOS, etc.).
   - **URL**: Optionally, you can provide a URL for your application.
   - **Description**: Optionally, you can provide a description for your application.
5. After submitting the form, you will receive your `api_id` and `api_hash`.

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


## Creating a Local Posgtres Instance using docker

- Create a `docker-compose.yml` file and add the following configuration.

::: code-group

```yml [docker-compose.yml]
services:
  postgres:
    image: ghcr.io/tgdrive/postgres:17-alpine
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