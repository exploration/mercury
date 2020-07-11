# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mercury,
  ecto_repos: [Mercury.Repo]

# Configures the endpoint
config :mercury, MercuryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hK548j1Z6MXA8Q/UB9wvWt5YQs8LC0n3o8KgTSfLQXLzEVnDurNG0JK0CZoiakYS",
  render_errors: [view: MercuryWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mercury.PubSub,
  live_view: [signing_salt: "5CEKkJMi"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
