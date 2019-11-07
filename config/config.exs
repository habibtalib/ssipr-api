# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ipr_api,
  ecto_repos: [IprApi.Repo]

# Configures the endpoint
config :ipr_api, IprApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QeDSf6w6wtfuXjuDEMM6hhl6oJH35zd5SHulwIC2H7txeihnLhIfUJheSgRmswOE",
  render_errors: [view: IprApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: IprApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian
config :ipr_api, IprApi.Guardian,
  issuer: "ipr_api",
  ttl: {30, :days},
  secret_key: "XcJhodiPTlPGoEdbOo79IU1/pFM2h3hlEWkE+/IArkihQSGkMkp5Gnq1F4uVxNbZ"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
