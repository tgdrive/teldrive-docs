# Setting Up Teldrive with Rclone

Teldrive integrates with rclone, allowing you to use your Telegram storage with familiar rclone commands and features.

## Installation

Install the Teldrive rclone remote using one of these methods:

::: code-group
```sh [macOS/Linux (curl)]
curl -sSL instl.vercel.app/tgdrive/rclone | bash
```

```powershell [PowerShell/cmd.exe]
powershell -c "irm https://instl.vercel.app/tgdrive/rclone?platform=windows|iex"
```
:::

## Feature Compatibility

| Feature              | Supported |
|----------------------|-----------|
| Purge                | Yes       |
| Copy                 | Yes       |
| Move                 | Yes       |
| DirMove              | Yes       |
| CleanUp              | Yes       |
| ListR                | No        |
| StreamUpload         | No        |
| MultithreadUpload    | Yes       |
| LinkSharing          | Yes       |
| About                | Yes       |
| EmptyDir             | Yes       |

For more information about rclone commands and features, visit the [official rclone documentation](https://rclone.org/docs/).

## Configuration Options

Configure rclone under the `[teldrive]` section in your rclone config file:

| Option | Description |
|--------|-------------|
| **`type`** | Must be "teldrive" |
| **`api_host`** | Host address of TelDrive API (default: "http://localhost:8080") |
| **`access_token`** | Session token from cookies for authentication |
| **`chunk_size`** | Maximum size for file chunks (default: "500M", max: "2GB") |
| **`upload_concurrency`** | Number of concurrent uploads (default: 4) |
| **`encrypt_files`** | Enable file encryption (default: false) |
| **`random_chunk_name`** | Use random names for file chunks (default: true) |

### Example Configuration

```toml
[teldrive]
type = "teldrive"
api_host = "http://localhost:8080"
access_token = "your_session_token_here"
chunk_size = "500M"
upload_concurrency = 4
encrypt_files = false
random_chunk_name = true
```

> [!IMPORTANT]
> To obtain your session token easily:
> 1. Install the [Cookie Editor](https://chromewebstore.google.com/detail/cookie-editor/hlkenndednhfkekhgcdicdfddnkalmdm) extension for Chrome or Firefox
> 2. Visit your Teldrive website
> 3. Open the extension and copy the value from the cookie named `access_token`
> 4. Alternatively, find the token in your browser's developer tools in the cookies section
