# Setup Teldrive with Rclone

# Installation

#### Linux and macOS

```bash
curl -sSL instl.vercel.app/tgdrive/rclone?move=1 | bash
```

#### Windows

```powershell
irm "https://instl.vercel.app/tgdrive/rclone?platform=windows&move=1" | iex
```

### Rclone Configuration Section
The configuration should be defined under the `[teldrive]` section in your config file.

**`type`**  
Must be set to "teldrive"

**`api_host`** (default: "http://localhost:8080")  
The host address where TelDrive API is running.

**`access_token`**  
Session token obtained from cookies for authentication.

**`chunk_size`** (default: "500M" , max: "2GB")
<br>
Maximum size of file chunks for uploads. Supports size units (B, K, M, G).

**`upload_concurrency`** (default: 4)  
Number of concurrent upload operations.

**`encrypt_files`** (default: false)  
Enable file encryption. Make sure encryption key is configured in TelDrive config file when enabled.

**`random_chunk_name`** (default: true)  
Use random names for file chunks when uploading to channel instead of original filename.

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
>- For obtaining session token from cookies  easily use this chrome [extension](https://chromewebstore.google.com/detail/cookie-editor/hlkenndednhfkekhgcdicdfddnkalmdm).This extension is also available for firefox.
>- Once extenion is installed go to teldrive website and copy values from cookie named `user-session`.
