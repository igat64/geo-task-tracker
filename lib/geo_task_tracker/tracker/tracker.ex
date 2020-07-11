defmodule GeoTaskTracker.Tracker do
  import Ecto.Query
  import Geo.PostGIS

  alias GeoTaskTracker.Repo
  alias GeoTaskTracker.Tracker.Task
  alias GeoTaskTracker.Accounts.User

  def get_task!(id) do
    Repo.get!(Task, id)
  end

  def create_task(attrs) do
    title = attrs["title"]
    pickup = attrs["pickup_point"]
    delivery = attrs["delivery_point"]

    data = %{
      status: "new",
      title: title,
      pickup_point: %Geo.Point{
        coordinates: {pickup["lat"], pickup["lon"]},
        srid: 4326
      },
      delivery_point: %Geo.Point{
        coordinates: {delivery["lat"], delivery["lon"]},
        srid: 4326
      }
    }

    %Task{}
    |> Task.changeset(data)
    |> Repo.insert()
  end

  def find_tasks_nearby(coordinates) do
    geo_point = %Geo.Point{coordinates: coordinates, srid: 4326}

    query =
      from task in Task,
        order_by: st_distance(task.pickup_point, ^geo_point),
        limit: 100

    {:ok, Repo.all(query)}
  end

  def pickup_task(%Task{} = task, %User{} = user) do
    task
    |> Task.changeset(%{status: "assigned", assigned_user_id: user.id})
    |> Repo.update()
  end

  def complete_task(%Task{} = task) do
    task
    |> Task.changeset(%{status: "done"})
    |> Repo.update()
  end

  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end
end
