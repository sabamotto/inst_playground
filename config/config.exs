# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :inst_playground, InstPlaygroundWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "e3WZfH4odwfU4Z0hTNMl6E9JJHtlmYWJu47UC7u8lMFZP53pMDmBG6TIXS2reULK",
  render_errors: [view: InstPlaygroundWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: InstPlayground.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Slime template engine
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine,
  slimleex: PhoenixSlime.LiveViewEngine

config :inst_playground, TradeCoreWeb.Gettext, default_locale: "en"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
