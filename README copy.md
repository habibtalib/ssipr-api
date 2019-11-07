# IprApi

> API Server for SSIPR

-------------------------------------------------
### Deps
|Library :|Version|
|--------|:------|
|Erlang/OTP|21|
|Elixir|1.8.2|
|Phoenix|1.4.6|

-------------------------------------------------
## Setup
``` bash
$ touch config/dev.exs
# You can override dev config here.
```

## Start

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

-------------------------------------------------
### STAGING & PRODUCTION ACCESS + DEPLOYMENT (REFER IP IN .deliver/config file)

``` bash
# Access to server. Make sure your ssh PubKey already added to the server. Contact the owner if you haven't.
$ ssh deploy@IP
```

> Change `PRODUCTION_HOSTS` to target sever's IP (REFER IP IN .deliver/config file). 

``` bash
# Build
$ mix edeliver build release

# Deploy
$ mix edeliver deploy release

# Migrate
$ mix edeliver migrate

# Restart Server
$ mix edeliver restart
```

> *Put production at the end of the command for PRODUCTION deployment. E.g. mix edeliver build release production.

