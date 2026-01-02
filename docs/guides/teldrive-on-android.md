# TelDrive on Android (Termux)

## Prerequisites (Android / Termux)

Before setting up Teldrive on Android, ensure you have the following in place.

### Required Components

1. Follow this Section from [1 to 3](https://teldrive-docs.pages.dev/docs/getting-started/prerequisites#required-components)

2. **Termux Environment**  
   Teldrive runs using a prebuilt binary inside the Termux application (APK).

---

## Database Option and Telegram API Keys

We will use **Supabase (cloud-hosted PostgreSQL)** for this setup.

### Using Supabase

1. Follow this Section: [Option 1](https://teldrive-docs.pages.dev/docs/getting-started/prerequisites#option-1-using-supabase-recommended-for-beginners)

**Important:**
- Enable the **pgroonga** extension in your Supabase project:
  - Open the dashboard search bar.
  - Type **Extensions**.
  - Find/Search and enable **pgroonga**.

---

## Getting Telegram `api_id` and `api_hash`

Follow these steps to obtain your Telegram API credentials.

1. Go to [Telegram Authorization](https://my.telegram.org/auth).

2. **Log in to the Developer Portal**  
   Access the **Telegram My Apps** page.

3. **Verify Your Account**
   - Enter your phone number in international format (e.g, `+1234567890`).
   - A confirmation code will be sent **via the Telegram app** (not SMS).
   - Enter the code to sign in.

4. **Access API Tools**  
   Select **API development tools** from the menu.

5. **Create a New Application**
   - Fill out the **Create new application** form.
   - Required fields:
     - **App title**
     - **Short name**
   - Optional fields (such as **URL**) can be left blank or filled with placeholders.

6. **Retrieve API Keys**  
   After submission, your **`api_id`** and **`api_hash`** will be displayed.

> **Note:**  
> Copy both keys and save them somewhere safe. You will need them later.  
> Once all prerequisites are ready, proceed to the installation section.

---

## Installation

### Installing Termux

Before continuing, ensure that Termux is installed correctly.

#### Download Sources (Recommended)

Install Termux **only** from one of the following official sources:

- **F-Droid:** https://f-droid.org/en/packages/com.termux/
- **GitHub Releases:** https://github.com/termux/termux-app/releases

> **Important:**  
> Do **not** install Termux from the Google Play Store.  
> The Play Store version is outdated and no longer supported.

---

### Choosing the Correct APK (ARM vs ARM64)

When installing from GitHub releases, you may see multiple APK variants:

- **`arm64-v8a`** — Recommended for most modern Android devices  
- **`armeabi-v7a`** — For older 32-bit ARM devices  
- **`universal.apk`** — Works on all devices  

> If you are **not sure** which architecture your device uses, install **`universal.apk`**.

---

### Initial Termux Setup

After opening Termux for the first time:

1. Allow storage access when prompted.

2. Copy and paste the following command into Termux:
   ```bash
   termux-setup-storage
   ```

3. Update and upgrade packages:
   ```bash
   pkg update && pkg upgrade
   ```

Once completed, Termux is ready for use.

---

### Method-1: One-Line Installers
```bash
curl -sSL "https://instl.vercel.app/teldrive?move=0" | (cd $PREFIX/bin && bash)
```
- Note: [see more](https://teldrive-docs.pages.dev/docs/getting-started/installation#installation)


### Method-2: Manual Installation

Teldrive provides multiple Linux builds. On Android devices, **only ARM-based binaries are relevant**.

- **arm64 (`linux-arm64`)**  
  Recommended for most Android phones. Works on modern 64-bit ARM devices.

- **arm (`linux-arm`)**  
  Intended for older 32-bit ARM devices. Use only if ARM64 is not supported.

> **Warning:**  
> `linux-amd64` builds are for PCs and servers (Intel/AMD CPUs) and **must not be used on Android**.

Check your device architecture
1. Open termux, paste anywhere then hit Enter

```bash
getprop ro.product.cpu.abi
```

2. Download the appropriate binary from the  
**[latest release assets](https://github.com/tgdrive/teldrive/releases)**


### Downloading and Extracting TelDrive

After downloading the Teldrive archive, extract it inside Termux.

> This section uses example filenames and paths.  
> Replace them with the actual file name you downloaded.  
> Let's take `linux-arm64` for example.

### Example Download Location

```text
/storage/emulated/0/Download/
```

Example file name:

```text
teldrive-<version>-linux-arm64.tar.gz
```

---

### Create a Directory for Teldrive (Optional but recommended)

```bash
mkdir ~/Teldrive
```

> You may choose any directory name or location you prefer.

---

### Extract the Archive

```bash
tar -xzf /storage/emulated/0/Download/teldrive-<version>-linux-arm64.tar.gz -C ~/Teldrive
```

> Here I'm using default `/storage/emulated/0/Download/` download path in android.  
> Replace the version number or just copy the file path instead.

---

### Verify the Extraction

```bash
cd ~/Teldrive
ls
```

Expected output:

```text
teldrive
LICENSE
README.md
```

---

### Make the Binary Executable

```bash
chmod +x teldrive
```

The Teldrive binary is now ready to use.

---

## Creating and Editing `config.toml`

Ensure you are inside the Teldrive directory:

```bash
cd ~/Teldrive
```

Create and open the configuration file:

```bash
nano config.toml
```

> If the file does not exist, `nano` will create it automatically.

---

### Basic `config.toml` (Recommended for New Users)

1. Copy this template from  
   [Configuration for Supabase database](https://teldrive-docs.pages.dev/docs/getting-started/usage#configuration-for-supabase-database)

2. Important Configuration Values [follow here](https://teldrive-docs.pages.dev/docs/getting-started/usage#important-configuration-values) 
3. Generate Secret Keys [Here](https://teldrive-docs.pages.dev/docs/getting-started/usage#generate-secret-keys)
4. Additionally you also need to include telegram configuration:

```toml
[tg]
app-id = "your-app-id"
app-hash = "your-app-hash"
rate-limit = false
```

**Important:**
- Make sure you have followed the configuration mentioned in the section link above.
- Replace API keys `your-app-id` and `your-app-hash` with the values you saved earlier
- Set `rate-limit = true` if you experience API limits
- You can also check out  
  [advanced usage](https://teldrive-docs.pages.dev/docs/getting-started/advanced#advanced-usage)  
  if you want to include extra values

---

### Saving and Exiting Nano

- Press **Ctrl + O** to save  
- Press **Enter** to confirm  
- Press **Ctrl + X** to exit  

---

> **Final Note**  
> After saving `config.toml`, make sure the Teldrive binary is executable and start the service:
>
> ```bash
> chmod +x teldrive
> ./teldrive run
> ```

---

## Accessing TelDrive

- Open `http://localhost:8080` in your browser.
- Log in with your Telegram account.
- Sync channels from **UI Settings**.
- Set a default channel from **UI Settings**.

> [NOTE](https://teldrive-docs.pages.dev/docs/getting-started/usage#accessing-teldrive)

