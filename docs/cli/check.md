# Usage

### What Does `check` Do?

The `check` command performs a thorough inspection of your Telegram file storage. Specifically, it:

1. **Identifies Missing File Parts**: Scans your Telegram storage to find any file parts that are missing.
2. **Detects Orphan File Parts**: Finds file parts that do not belong to any complete file.
3. **Cleans Up**: With the `--clean` flag, it removes any detected missing or orphan file parts to free up space and keep your storage organized.
4. **Exports Incomplete Files**: With the `--export` flag, it exports details of incomplete files to a JSON file for further analysis or record-keeping.

### Flags

- `--clean`  
  Clean missing and orphan file parts.
  
- `-c, --config string`  
  Config file path (default is `$HOME/.teldrive/config.toml`).
  
- `--export`  
  Export incomplete files to a JSON file (default is `true`).
  
- `-h, --help`  
  Help for the `check` command.
  
- `--user string`  
  Telegram User Name.