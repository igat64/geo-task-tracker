# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :geo_task_tracker,
  ecto_repos: [GeoTaskTracker.Repo]

# Configures the endpoint
config :geo_task_tracker, GeoTaskTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OHJfzb7Y0ArREWE+kblEaAmLuyaoQ5TDn66BCbn8lEjr69qpyFl7Yj/seWtiE7Ac",
  render_errors: [view: GeoTaskTrackerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GeoTaskTracker.PubSub,
  live_view: [signing_salt: "qbASDK+A"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
