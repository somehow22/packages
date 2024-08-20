# Custom Caddy Server

This directory contains the configuration for a custom Caddy server build, part of the versatile package manager.

## Features

- Custom Caddy build with additional modules
- Automatic HTTPS
- HTTP/3 support
- Reverse proxy capabilities
- File server with directory browsing
- Customizable via Caddyfile

## Additional Modules

This custom Caddy build includes the following additional modules:

- github.com/mholt/caddy-events-exec
- github.com/mholt/caddy-l4
- github.com/mholt/caddy-ratelimit
- github.com/caddyserver/cache-handler

## Files

- `Dockerfile`: Defines the custom Caddy build
- `Caddyfile`: Configuration file for Caddy
- `docker-compose.yml`: Compose file for easy deployment

## Usage

1. Customize the `Caddyfile` to your needs
2. Run the following command in this directory:

## Additional Resources

- [Official Caddy Documentation](https://caddyserver.com/docs/)
- [Caddyfile Syntax](https://caddyserver.com/docs/caddyfile)
- [Caddy Modules](https://caddyserver.com/docs/modules/)