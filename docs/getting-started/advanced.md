# Advanced Usage

This guide covers advanced Teldrive configuration options to enhance performance and security.

## Multi-Threaded Streams

If you experience buffering issues, enable multi-threaded options to significantly improve streaming performance:

```toml
[tg.stream]
multi-threads = 4
stream-buffers = 12
```
For Rclone use these options:
```
--vfs-read-chunk-size=12M
--vfs-read-chunk-streams=20
--teldrive-threaded-streams=1
```

> [!NOTE] 
> - You may not need this if your telegram dc is close to your location.
> - Keep `multi-threads` value at 8 or lower to prevent excessive CPU usage.
> - You can tweak these params to find the best performance for your connection.Don't set `vfs-read-chunk-size` too high, as it may cause buffering issues.

## File Encryption

Enable file encryption to secure your data:

```toml
[tg.uploads]
encryption-key = "your-key"
```

You can generate a secure random encryption key using the [key generator tool](/docs/getting-started/usage.md#generate-secret-keys) in the usage guide.

> [!NOTE]
> - Add `encrypt_files = true` in your rclone config when enabling encryption
> - Store your encryption key securely - you can't recover files without it
> - Teldrive's encryption is more secure than rclone's crypt implementation as it generates a random salt for each file part rather than using the same salt for all files
> - Enabling encryption in Teldrive makes the UI fully compatible with encrypted files

## Adding Bot Tokens

Bot tokens are essential for optimal Telegram API interaction. To create and add bot tokens:

1. Open Telegram and search for `@BotFather`
2. Start a chat and type `/newbot`
3. Follow the prompts to set a name and username (must end with `bot`)
4. BotFather will provide your bot token
5. Add 7-8 bot tokens in the Teldrive UI Settings for better upload/download speeds

> [!WARNING]
> Bots will be automatically added as admins in your channel when set through the UI. If this fails, add them manually.
> For newly created Telegram sessions, you must wait 20-30 minutes before adding bots to a channel. You'll see a **`FRESH_CHANGE_ADMINS_FORBIDDEN`** error if you try too soon.

## Using a Thumbnail Resizer

Teldrive supports on-the-fly image resizing using `imgproxy` for thumbnail viewing:

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

Start the service:
```sh
docker compose up -d
```

For better performance:
- Deploy imgproxy behind Cloudflare or another web server with caching
- Enter the URL of your deployed resizer service in the Teldrive UI settings
