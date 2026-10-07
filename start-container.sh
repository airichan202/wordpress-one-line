#!/bin/sh
set -eu

WP_DIR="/app/wordpress"

if [ ! -d "$WP_DIR" ]; then
  echo "ERROR: WordPress directory not found at $WP_DIR"
  exit 1
fi

# Create wp-config.php from Skalo environment variables on first start.
# WordPress itself can then finish the normal web installer.
if [ ! -f "$WP_DIR/wp-config.php" ]; then
  : "${WORDPRESS_DB_NAME:?WORDPRESS_DB_NAME is required}"
  : "${WORDPRESS_DB_USER:?WORDPRESS_DB_USER is required}"
  : "${WORDPRESS_DB_PASSWORD:?WORDPRESS_DB_PASSWORD is required}"
  : "${WORDPRESS_DB_HOST:?WORDPRESS_DB_HOST is required}"

  TABLE_PREFIX="${WORDPRESS_TABLE_PREFIX:-wp_}"
  DEBUG="${WORDPRESS_DEBUG:-false}"

  cat > "$WP_DIR/wp-config.php" <<PHP
<?php
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
\$table_prefix = '${TABLE_PREFIX}';

define('WP_DEBUG', ${DEBUG});
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);

if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
PHP
fi

exec "$@"
