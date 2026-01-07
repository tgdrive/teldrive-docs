# Teldrive on Android (Termux)

## Prerequisites

Setting up Teldrive on Android, ensure you have the following in place.

### Before you begin

- Read the main [Prerequisites guide.](/docs/getting-started/prerequisites).
- An installed Termux.

## Database and Telegram setup

This guide only covers Supabase (cloud-hosted) and does not include local database setup.

### Getting Telegram `api_id` and `api_hash`

Follow these steps to obtain your Telegram API credentials.

1. Go to [Telegram Authorization](https://my.telegram.org/auth).

2. **Log in to the Developer Portal**
   Access the **Telegram My Apps** page.

3. **Verify Your Account**
   - Enter your phone number in international format (e.g., `+1234567890`).
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

> [!Note]
> - Copy both keys and store them securely. You will need them later.
> - Once all prerequisites are ready, proceed to the installation section.

## Installation

### Installing Termux

Before continuing, ensure that Termux is installed correctly.

### Download Sources

Install Termux **only** from one of the following official sources:

- **F-Droid:** https://f-droid.org/en/packages/com.termux/
- **GitHub Releases:** https://github.com/termux/termux-app/releases

> [!Important]
> - Do **not** install Termux from the Google Play Store.
> - The Play Store version is outdated and no longer supported.

### Choosing the Correct APK

When installing from GitHub releases, you may see multiple APK variants:

- **`arm64-v8a`** — Recommended for most modern Android devices  
- **`armeabi-v7a`** — For older 32-bit ARM devices  
- **`universal.apk`** — Works on all devices  

> If you are **not sure** which architecture your device uses, install **`universal.apk`**, which works on all devices.

### Initial Termux Setup

After opening Termux for the first time:

1. Allow storage access when prompted.

2. Run the following command in Termux:
   ```bash
   termux-setup-storage
   ```

3. Update and upgrade packages:
   ```bash
   pkg update && pkg upgrade
   ```
> Once completed, Termux is ready for use.

### Method: One-line installer

- [Follow Here](/docs/getting-started/installation)

## Configuration

- Read [this](/docs/getting-started/usage#configuration)

### Basic `config.toml` (Recommended for New Users)

1. First, read the [/usage documentation](docs/getting-started/usage) for configuring a Supabase database.

2. Create and open the configuration file:

```bash
nano config.toml
```

> [!NOTE]
> - If the file does not exist, `nano` will create it automatically.
> - View a complete sample configuration at the [GitHub repository](https://github.com/tgdrive/teldrive/blob/main/config.sample.toml)

### Saving and Exiting Nano

- Press **Ctrl + O** to save
- Press **Enter** to confirm
- Press **Ctrl + X** to exit

> To run Teldrive, follow the instructions here. [Running without Docker](/docs/getting-started/usage#running-without-docker) 

## Accessing Teldrive

- Open http://localhost:8080 in your browser.
> See the main guide:  [Here](/docs/getting-started/usage#accessing-teldrive)
