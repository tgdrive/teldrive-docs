# Advanced Usage

## Using Multi Threaded streams

If content is buffering you can enable multi threaded options in config.This will improve streaming performance significantly.

```toml
[tg.stream]
multi-threads=8
stream-buffers=16
```
> [!NOTE]  
You needed also add `threaded_streams = true` in rclone config also  to enable multi threaded streams

These values are good starting point otherwise try to tinker these acc to your usage.

## Adding Bot tokens

A bot token is essential for interacting with the Telegram API for upload and downloads. To create a bot token, follow these steps:

1. Open the Telegram app on your device.
2. Search for `@BotFather` and start a chat with it.
3. Type `/newbot` and follow the prompts to set up your new bot.
   - You will need to choose a name for your bot.
   - You will also need to choose a username for your bot; it must end with `bot`. For example, `my_sample_bot`.
4. Once you have completed these steps, you will receive a message containing your bot token.
5. Add around 7-8 tokens for better upload and download speeds.