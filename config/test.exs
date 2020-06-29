use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :geo_task_tracker, GeoTaskTracker.Repo,
  username: "igat",
  password: "",
  database: "geo_task_tracker_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  extensions: [{Geo.PostGIS.Extension, library: Geo}]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :geo_task_tracker, GeoTaskTrackerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
