FROM --platform=$BUILDPLATFORM node:22-bookworm-slim AS node
FROM --platform=$BUILDPLATFORM rust:1.70-bookworm AS rust

FROM --platform=$BUILDPLATFORM elixir:1.14.5-otp-26-slim AS build

# install build dependencies
ENV DEBIAN_FRONTEND=noninteractive
ENV CARGO_HOME=/usr/local/cargo
ENV RUSTUP_HOME=/usr/local/rustup
ENV PATH=/usr/local/cargo/bin:$PATH
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=rust /usr/local/cargo /usr/local/cargo
COPY --from=rust /usr/local/rustup /usr/local/rustup
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    openssl && \
    rm -rf /var/lib/apt/lists/*

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
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile

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
FROM debian:trixie-slim AS app
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    libncurses6 \
    libstdc++6 \
    openssl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /app/_build/prod/rel/ketbin ./
COPY source/startup.sh ./

RUN chmod +x /app/startup.sh && \
    chown -R nobody:nogroup /app

USER nobody

ENV HOME=/app

CMD ["/app/startup.sh"]
