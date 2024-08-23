# Katbin

This directory contains the configuration for Katbin, a pastebin service written in Kotlin, as part of the versatile package manager.

## Features

- Pastebin functionality
- Written in Kotlin
- Containerized for easy deployment

## Files

- `Dockerfile`: Defines the Katbin build and runtime environment
- `source/`: Git submodule containing the Katbin source code

## Usage

1. Ensure you've initialized and updated the git submodule:
   ```
   git submodule update --init --recursive
   ```
2. Build the Docker image using the provided Dockerfile
3. Run the container, exposing port 8080

For more details on Katbin, please refer to the original project: [https://github.com/sphericalkat/katbin](https://github.com/sphericalkat/katbin)
