defmodule GeoTaskTracker.Tracker do
  import Ecto.Query
  import Geo.PostGIS

  alias GeoTaskTracker.{Task, User, Repo}

  def create_task(attrs, _user) do
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

  def find_tasks_nearby(coordinates, _user) do
    geo_point = %Geo.Point{coordinates: coordinates, srid: 4326}

    query =
      from task in Task,
        order_by: st_distance(task.pickup_point, ^geo_point),
        limit: 100

    {:ok, Repo.all(query)}
  end

  def pickup_task(id, %User{} = user) do
    task = Repo.get(Task, id)

    case task do
      %Task{} ->
        task
        |> Task.changeset(%{
          assigned_user_id: user.id,
          status: "assigned"
        })
        |> Repo.update()

      _ ->
        {:error, :not_found}
    end
  end

  def complete_task(id, _user) do
    task = Repo.get(Task, id)

    case task do
      %Task{} ->
        task
        |> Task.changeset(%{status: "done"})
        |> Repo.update()

      _ ->
        {:error, :not_found}
    end
  end

  def delete_task(id, _user) do
    task = Repo.get(Task, id)

    case task do
      %Task{} ->
        Repo.delete(task)

      _ ->
        {:error, :not_found}
    end
  end
end
