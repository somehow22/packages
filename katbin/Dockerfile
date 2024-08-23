FROM elixir:1.14-alpine AS build

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
RUN mix local.hex --force && \
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

# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine AS app
RUN apk add --no-cache openssl ncurses-libs libstdc++

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/ketbin ./

# Copy our custom startup.sh
COPY source/startup.sh /app/startup.sh

RUN chmod +x /app/startup.sh

ENV HOME=/app

CMD ["/app/bin/ketbin", "start"]