defmodule GeoTaskTrackerWeb.TaskController do
  use GeoTaskTrackerWeb, :controller

  alias GeoTaskTracker.Tracker

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.user]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, params, user) do
    case Tracker.create_task(params, user) do
      {:ok, task} ->
        conn
        |> put_status(201)
        |> render("task.json", task: task)

      {:error, :forbidden} ->
        resp(conn, 403, "")

      _ ->
        resp(conn, 500, "")
    end
  end

  def find_nearby(conn, %{"lat" => lat, "lon" => lon}, user) do
    case Tracker.find_tasks_nearby({lat, lon}, user) do
      {:ok, tasks} ->
        conn
        |> put_status(200)
        |> render("tasks.json", tasks: tasks)
    end
  end

  def pickup(conn, %{"id" => id}, user) do
    case Tracker.pickup_task(id, user) do
      {:ok, task} ->
        conn
        |> put_status(201)
        |> render("task.json", task: task)

      {:error, :forbidden} ->
        resp(conn, 403, "")

      {:error, :not_found} ->
        resp(conn, 404, "")

      _ ->
        resp(conn, 500, "")
    end
  end

  def complete(conn, %{"id" => id}, user) do
    case Tracker.complete_task(id, user) do
      {:ok, task} ->
        conn
        |> put_status(201)
        |> render("task.json", task: task)

      {:error, :forbidden} ->
        resp(conn, 403, "")

      {:error, :not_found} ->
        resp(conn, 404, "")

      _ ->
        resp(conn, 500, "")
    end
  end

  def delete(conn, %{"id" => id}, user) do
    case Tracker.delete_task(id, user) do
      {:ok, _} ->
        resp(conn, 204, "")

      {:error, :forbidden} ->
        resp(conn, 403, "")

      {:error, :not_found} ->
        resp(conn, 404, "")

      _ ->
        resp(conn, 500, "")
    end
  end
end
