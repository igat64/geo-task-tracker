defmodule GeoTaskTracker.Factories do
  use ExMachina.Ecto, repo: GeoTaskTracker.Repo

  def user_factory(%{role: role}) do
    %GeoTaskTracker.Accounts.User{
      name: sequence("user_"),
      role: role
    }
  end

  def task_factory(attrs) do
    status = Map.get(attrs, :status, "new")

    %GeoTaskTracker.Tracker.Task{
      status: status,
      title: sequence("task_"),
      pickup_point: %Geo.Point{
        coordinates: {0, -90},
        srid: 4326
      },
      delivery_point: %Geo.Point{
        coordinates: {0, 90},
        srid: 4326
      }
    }
  end
end
