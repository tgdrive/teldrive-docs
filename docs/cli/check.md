# Storage Integrity Check

The `check` command helps you maintain the integrity of your Teldrive storage by identifying and resolving file part issues.

## What Does the Command Do?

The `check` command performs a comprehensive analysis of your Telegram file storage to:

1. **Find Missing File Parts**: Identifies file parts that are referenced in your database but no longer exist in Telegram storage
2. **Detect Orphaned Parts**: Discovers file parts in Telegram storage that aren't properly linked to any file in your database
3. **Clean Up Storage**: With the `--clean` flag, removes identified problematic file parts to optimize your storage
4. **Export Details**: With the `--export` flag, saves information about incomplete files to a JSON file for further analysis

## Command Options

- `--clean`  
  Remove any detected missing or orphaned file parts from your storage.
  
- `-c, --config string`  
  Specify a custom config file path (default is `$HOME/.teldrive/config.toml`).
  
- `--export`  
  Export details of incomplete files to a JSON file for further analysis (enabled by default).
  
- `-h, --help`  
  Display help information for the `check` command.
  
- `--user string`  
  Specify a Telegram username to check files for a specific user.

## Example Usage

Basic integrity check:
```bash
teldrive check
```

Check and clean up storage:
```bash
teldrive check --clean
```

Check a specific user's storage:
```bash
teldrive check --user yourTelegramUsername
```

Using a custom config file:
```bash
teldrive check -c /path/to/config.toml
```
