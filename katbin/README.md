# Katbin

This directory contains the configuration for Katbin, a pastebin service written in Elixir.

## Prerequisites

- Docker and Docker Compose installed
- Access to the Katbin Docker image

## Setup and Usage

1. Create a `docker-compose.yml` file:

```yaml

services:
  katbin-db:
    image: postgres:16-alpine
    container_name: katbin-db
    environment:
      POSTGRES_DB: katbin
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: katbin
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - katbin-network

  katbin:
    image: ghcr.io/somehow22/katbin
    depends_on:
      - katbin-db
    ports:
      - "8080:8080"
    env_file:
      - .env
    networks:
      - katbin-network

volumes:
  postgres_data:

networks:
  katbin-network:
```

2. Generate a SECRET_KEY_BASE:
   ```
   openssl rand -base64 64
   ```
   Copy the output for use in the next step.

3. Create a `.env` file and configure the environment variables:
   ```
   DATABASE_URL=postgres://postgres:katbin@db:5432/katbin
   SECRET_KEY_BASE=<paste_generated_secret_here>
   SWOOSH_USERNAME=your_email@example.com
   SWOOSH_PASSWORD=your_email_password
   SWOOSH_SMTP_RELAY=smtp.your-email-provider.com
   ```
   Be sure to replace the placeholders with your actual SMTP credentials.

4. Start the services:
   ```
   docker-compose up -d
   ```

5. Check the logs:
   ```
   docker-compose logs -f katbin
   ```
   Look for any error messages or confirmation that the service has started successfully.

6. Access Katbin at `http://localhost:8080`

For more details on Katbin, please refer to the original project: [https://github.com/sphericalkat/katbin](https://github.com/sphericalkat/katbin)