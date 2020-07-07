defmodule GeoTaskTrackerWeb.TaskController do
  use GeoTaskTrackerWeb, :controller

  alias GeoTaskTracker.Tracker

  action_fallback GeoTaskTrackerWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.user]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, params, user) do
    with {:ok, task} <- Tracker.create_task(params, user) do
      conn
      |> put_status(201)
      |> render("show.json", task: task)
    end
  end

  def find_nearby(conn, %{"lat" => lat, "lon" => lon}, user) do
    {:ok, tasks} = Tracker.find_tasks_nearby({lat, lon}, user)

    conn
    |> put_status(200)
    |> render("index.json", tasks: tasks)
  end

  def pickup(conn, %{"id" => id}, user) do
    with {:ok, task} <- Tracker.pickup_task(id, user) do
      conn
      |> put_status(201)
      |> render("show.json", task: task)
    end
  end

  def complete(conn, %{"id" => id}, user) do
    with {:ok, task} <- Tracker.complete_task(id, user) do
      conn
      |> put_status(201)
      |> render("show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    with {:ok, _} <- Tracker.delete_task(id, user) do
      resp(conn, 204, "")
    end
  end
end
