FROM --platform=$BUILDPLATFORM elixir:1.14-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git curl py-pip rust cargo

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY source/mix.exs source/mix.lock ./
COPY source/config config

# Update hex and rebar, then get and compile dependencies
RUN apk add --no-cache openssl ca-certificates && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

# build assets
COPY source/assets/package.json source/assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY source/priv priv
COPY source/assets assets
COPY source/lib lib
COPY source/native native
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# Build release
RUN mix do compile, release

# prepare release image
FROM --platform=$TARGETPLATFORM alpine:latest AS app
RUN apk add --no-cache openssl ncurses-libs libstdc++

WORKDIR /app

COPY --from=build /app/_build/prod/rel/ketbin ./
COPY source/startup.sh ./

RUN chmod +x /app/startup.sh && \
    chown -R nobody:nobody /app

USER nobody

ENV HOME=/app

# Set default environment variables
ENV DATABASE_URL=postgres://postgres:katbin@db:5432/katbin
ENV SECRET_KEY_BASE='default_secret_key_base_change_me_in_production'
ENV SWOOSH_USERNAME='noreply@katb.in'
ENV SWOOSH_PASSWORD='default_password_change_me'
ENV SWOOSH_SMTP_RELAY='smtp.example.com'

CMD ["/app/startup.sh"]