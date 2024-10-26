# Sing-box

This directory contains the configuration for Sing-box, a universal proxy platform.

## Features

- Supports multiple protocols including Shadowsocks, VMess, Trojan, and more
- Rule-based routing
- DNS over HTTPS/TLS
- Transparent proxy support
- And more...

## Usage

The Sing-box Docker image is built and pushed to the GitHub Container Registry automatically via GitHub Actions. You can use Docker Compose to run it:

1. Create a `config.json` file in the same directory as the `docker-compose.yml` file with your Sing-box configuration.

2. Run the following command:
   ```
   docker-compose up -d
   ```

This will pull the latest Sing-box image and start the container with your configuration.

## Configuration

Sing-box uses a JSON configuration file. You need to create a `config.json` file in the same directory as your `docker-compose.yml` file.

For more details on configuring Sing-box, please refer to the official documentation: [Sing-box Configuration](https://sing-box.sagernet.org/configuration/)

## Building Locally

If you want to build the Docker image locally, you can use the following command in this directory:
