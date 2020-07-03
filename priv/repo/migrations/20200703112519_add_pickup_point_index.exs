defmodule GeoTaskTracker.Repo.Migrations.AddPickupPointIndex do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX IF NOT EXISTS tasks_pickup_point_idx ON tasks USING GIST (pickup_point)"
  end

  def down do
    execute "DROP INDEX IF EXISTS tasks_pickup_point_idx"
  end
end
