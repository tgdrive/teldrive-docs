# Command Line Options

### Cache Options
**`--cache-max-size`** (default: 10485760)  
Maximum cache size in bytes for in-memory storage.

**`--cache-redis-addr`**  
Redis server address for caching (e.g., "localhost:6379").

**`--cache-redis-pass`**  
Password for Redis server authentication.

### Config
**`-c, --config`** (default: $HOME/.teldrive/config.toml)  
Config file path.

### Cronjob Options
**`--cronjobs-enable`** (default: true)  
Enable or disable background cron jobs.

**`--cronjobs-clean-files-interval`** (default: 1h)  
Interval for cleaning up deleted files.

**`--cronjobs-clean-uploads-interval`** (default: 12h)  
Interval for cleaning incomplete uploads.

**`--cronjobs-folder-size-interval`** (default: 2h)  
Interval for updating folder size calculations.

### Database Options
**`--db-data-source`**  
Database connection string (required).

**`--db-log-level`** (default: info)  
Database logging verbosity level.

**`--db-pool-enable`** (default: true)  
Enable database connection pooling.

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
List of usernames allowed to access the service.

**`--jwt-secret`**  
Secret key for JWT token signing (required).

**`--jwt-session-time`** (default: 30d)  
Duration for which JWT tokens remain valid.

### Logging
**`--log-development`**  
Enable development mode logging.

**`--log-file`**  
File path for logging output.

**`--log-level`** (default: info)  
Logging level (debug,info,warn,error).

### Server Options
**`--server-enable-pprof`**  
Enable pprof profiling endpoint.

**`--server-graceful-shutdown`** (default: 15s)  
Grace period for server shutdown.

**`-p, --server-port`** (default: 8080)  
HTTP server port.

**`--server-read-timeout`** (default: 1h)  
Maximum duration for reading request body.

**`--server-write-timeout`** (default: 1h)  
Maximum duration for writing response.

### Telegram Options
**`--tg-app-hash`**  
Telegram application hash (required).

**`--tg-app-id`**  
Telegram application ID (required).

**`--tg-app-version`** (default: "4.6.3 K")  
Application version string.

**`--tg-device-model`** (default: "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/116.0")  
Device model string for Telegram client.

**`--tg-disable-stream-bots`**  
Disable streaming bots functionality.

**`--tg-enable-logging`**  
Enable Telegram client logging.

**`--tg-lang-code`** (default: "en")  
Language code for Telegram client.

**`--tg-lang-pack`** (default: "webk")  
Language pack identifier.

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

**`--tg-session-file`**  
Path to Telegram session file.

**`--tg-stream-buffers`** (default: 8)  
Number of streaming buffers.

**`--tg-stream-chunk-timeout`** (default: 20s)  
Timeout for fetching stream chunks.

**`--tg-stream-multi-threads`**  
Number of threads for streaming.

**`--tg-system-lang-code`** (default: "en-US")  
System language code.

**`--tg-system-version`** (default: "Win32")  
System version string.

**`--tg-uploads-encryption-key`**  
Encryption key for uploads.

**`--tg-uploads-max-retries`** (default: 10)  
Maximum retry attempts for uploads.

**`--tg-uploads-retention`** (default: 7d)  
Duration to retain upload data.

**`--tg-uploads-threads`** (default: 8)  
Number of concurrent upload threads.

**`--tg-ntp`** (default: false)  
Sync system clock with NTP(Network Time Protocol).

> [!NOTE] 
Duration values can be specified using units: "s" (seconds), "m" (minutes), "h" (hours), "d" (days). Required flags must be set either via command line or configuration file.
