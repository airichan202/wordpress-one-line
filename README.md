# WordPress for Skalo / Railpack

Single-process WordPress deployment for Skalo using Railpack.

## Skalo settings

- Repository: this repository
- Branch: `main`
- Builder: Railpack
- Port: `80`
- Replicas: `1`

## Required environment variables

Create/provision a MySQL or MariaDB database in Skalo, then add:

- `WORDPRESS_DB_HOST`
- `WORDPRESS_DB_NAME`
- `WORDPRESS_DB_USER`
- `WORDPRESS_DB_PASSWORD`

Optional:

- `WORDPRESS_TABLE_PREFIX` (default `wp_`)
- `WORDPRESS_DEBUG` (default `false`)

The startup script creates `wordpress/wp-config.php` from these variables if it does not exist. WordPress then shows its normal web installer.

## Important persistence

The WordPress directory is created during the image build. For production use, persistent storage should be configured for WordPress uploads, plugins, themes, and other writable data according to the storage options provided by Skalo.

This repository intentionally does not contain the WordPress core files; the build downloads the official WordPress release.
