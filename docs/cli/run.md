# Command Line Options

Teldrive offers various command line options to customize its behavior and performance. Below are the available options categorized by function.

### Cache Options
**`--cache-max-size`** (default: 10485760)  
Maximum cache size in bytes for in-memory storage.

**`--cache-redis-addr`**  
Redis server address for caching (e.g., "localhost:6379").

**`--cache-redis-pass`**  
Password for Redis server authentication.

### Config
**`-c, --config`** (default: $HOME/.teldrive/config.toml)  
Path to your configuration file.

### Cronjob Options
**`--cronjobs-enable`** (default: true)  
Enable or disable background cron jobs.

**`--cronjobs-clean-files-interval`** (default: 1h)  
How often to clean up deleted files.

**`--cronjobs-clean-uploads-interval`** (default: 12h)  
How often to clean incomplete uploads.

**`--cronjobs-folder-size-interval`** (default: 2h)  
How often to update folder size calculations.

### Database Options
**`--db-data-source`**  
Database connection string (required).

**`--db-log-level`** (default: info)  
Database logging verbosity level.

**`--db-pool-enable`** (default: true)  
Enable database connection pooling for better performance.

**`--db-pool-max-idle-connections`** (default: 25)  
Maximum number of idle connections in the pool.

**`--db-pool-max-lifetime`** (default: 10m)  
Maximum lifetime of a connection in the pool.

**`--db-pool-max-open-connections`** (default: 25)  
Maximum number of open connections.

**`--db-prepare-stmt`** (default: true)  
Enable prepared statements for better performance.

### JWT Authentication
**`--jwt-allowed-users`**  
List of Telegram usernames allowed to access the service.

**`--jwt-secret`**  
Secret key for JWT token signing (required).

**`--jwt-session-time`** (default: 30d)  
Duration for which JWT tokens remain valid.

### Logging

**`--log-file`**  
File path for logging output.

**`--log-level`** (default: info)  
Logging level (debug, info, warn, error).

### Server Options
**`--server-enable-pprof`**  
Enable pprof endpoint for performance profiling.

**`--server-graceful-shutdown`** (default: 15s)  
Grace period for server shutdown.

**`-p, --server-port`** (default: 8080)  
HTTP server port.

**`--server-read-timeout`** (default: 1h)  
Maximum duration for reading request body.

**`--server-write-timeout`** (default: 1h)  
Maximum duration for writing response.

### Telegram Options

**`--tg-disable-stream-bots`**  
Disable streaming bots functionality.

**`--tg-enable-logging`**  
Enable detailed Telegram client logging.

**`--tg-pool-size`** (default: 8)  
Size of Telegram session pool.

**`--tg-proxy`**  
HTTP/SOCKS5 proxy URL for Telegram connection.

**`--tg-rate`** (default: 100)  
Rate limit for Telegram API calls.

**`--tg-rate-burst`** (default: 5)  
Maximum burst size for rate limiting.

**`--tg-rate-limit`** (default: true)  
Enable rate limiting for Telegram API.

**`--tg-reconnect-timeout`** (default: 5m)  
Timeout for reconnection attempts.

**`--tg-storage-file`**  
SQLite storage file path.

**`--tg-stream-buffers`** (default: 8)  
Number of streaming buffers.

**`--tg-stream-chunk-timeout`** (default: 20s)  
Timeout for fetching stream chunks.

**`--tg-stream-multi-threads`**  
Number of threads for streaming.

**`--tg-uploads-encryption-key`**  
Encryption key for uploads.

**`--tg-uploads-max-retries`** (default: 10)  
Maximum retry attempts for uploads.

**`--tg-uploads-retention`** (default: 7d)  
Duration to retain upload data.

**`--tg-uploads-threads`** (default: 8)  
Number of concurrent upload threads.

**`--tg-ntp`** (default: false)  
Sync system clock with NTP (Network Time Protocol).

> [!NOTE] 
> Duration values can be specified using units: "s" (seconds), "m" (minutes), "h" (hours), "d" (days). Required flags must be set either via command line or configuration file.
