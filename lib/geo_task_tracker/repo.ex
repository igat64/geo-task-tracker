defmodule GeoTaskTracker.Repo do
  use Ecto.Repo,
    otp_app: :geo_task_tracker,
    adapter: Ecto.Adapters.Postgres
end
