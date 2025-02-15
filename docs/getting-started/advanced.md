# Advanced Usage

## Using Multi Threaded streams

If content is buffering you can enable multi threaded options in config.This will improve streaming performance significantly.

```toml
[tg.stream]
multi-threads=8
stream-buffers=16
```
> [!NOTE]  
>- Also add `threaded_streams = true` in rclone config to enable multi threaded streams.
>- Keep in mind that enabling multi-threaded streams will increase the load on your server.
>- Dont't set `multi-threads` value more than 16 as it will cause high cpu usage.

## Using File Encryption

```toml
[tg.uploads]
encryption-key = "your-key"
```

> [!NOTE]
>- Also add `encrypt_files = true` in rclone config to enable encryption.
>- Keep your password safe once generated teldrive uses same encryption as of rclone internally 
so you don't need to enable crypt in rclone.
>- Teldrive generates random salt for each file part and saves in database so its more secure than rclone crypt whereas in rclone same salt value  is used  for all files which can be compromised easily. Enabling crypt in rclone makes UI redundant so encrypting files in teldrive internally is better way to encrypt files and more secure encryption than rclone.To encrypt files see more about teldrive rclone config.

## Adding Bot tokens

A bot token is essential for interacting with the Telegram API for upload and downloads. To create a bot token, follow these steps:

1. Open the Telegram app on your device.
2. Search for `@BotFather` and start a chat with it.
3. Type `/newbot` and follow the prompts to set up your new bot.
   - You will need to choose a name for your bot.
   - You will also need to choose a username for your bot; it must end with `bot`. For example, `my_sample_bot`.
4. Once you have completed these steps, you will receive a message containing your bot token.
5. Add around 7-8 tokens for better upload and download speeds in UI Settings.

> [!WARNING]
> Bots will be auto added as admin in channel if you set them from UI if it fails somehow add it manually.For newly logged session you have to wait 20-30 min to add bots to telegram channel. **`FRESH_CHANGE_ADMINS_FORBIDDEN`** error  will be thrown if you try to add bots before that time frame.

## Using Thumbnail Resizer

- Teldrive supports image resizing on the fly using `imgproxy` for thumbnail viewing.

::: code-group

```yml [docker-compose.yml]
services:
  imgproxy:
    image: darthsim/imgproxy
    container_name: imgproxy
    environment:
      IMGPROXY_ALLOW_ORIGIN: "*"
      IMGPROXY_ENFORCE_WEBP: true
      IMGPROXY_MALLOC: "jemalloc"
    restart: always
    ports:
      - 8000:8080
```
:::

```sh
docker compose up -d
```
- As imgproxy doesn't support caching so its recommended to use this behind `cloudflare` or any webserver that supports caching.

- Enter url of deployed resizer service in teldrive UI settings.
