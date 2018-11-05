FROM bitwalker/alpine-elixir:1.7.3 as build

ENV HOME=/opt/app

RUN apk add --no-cache build-base cmake
RUN mix do local.hex --force, local.rebar --force

COPY mix.exs $HOME/mix.exs
COPY config $HOME/config
COPY apps $HOME/apps
COPY rel $HOME/rel

WORKDIR $HOME

ENV MIX_ENV=prod

RUN mix deps.get && mix deps.compile
RUN mix release --env=$MIX_ENV --verbose

FROM alpine:3.8

ENV HOME=/opt/app/

ENV APP_VERSION=0.1.1

RUN apk add --no-cache openssl bash postgresql-client

COPY --from=build $HOME/_build/prod/rel/mirror/releases/$APP_VERSION/mirror.tar.gz $HOME

WORKDIR $HOME

RUN tar -xzf mirror.tar.gz

ENTRYPOINT ["/opt/app/bin/mirror"]
CMD ["foreground"]
