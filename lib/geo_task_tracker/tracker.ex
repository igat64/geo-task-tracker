defmodule GeoTaskTracker.Tracker do
  alias GeoTaskTracker.{Task, User, Repo}

  def create_task(attrs) do
    pickup = Map.get(attrs, "pickup_point")
    delivery = Map.get(attrs, "delivery_point")

    changes = %{
      status: "new",
      title: attrs["title"],
      pickup_point: %Geo.Point{
        coordinates: {pickup["lat"], pickup["lon"]}
      },
      delivery_point: %Geo.Point{
        coordinates: {delivery["lat"], delivery["lon"]}
      }
    }

    %Task{}
    |> Task.changeset(changes)
    |> Repo.insert()
  end
end
