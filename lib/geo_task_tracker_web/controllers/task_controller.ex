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

  def find_nearby(conn, _params, user) do
  end

  def pickup(conn, %{"id" => id}, user) do
    task_id = String.to_integer(id)

    case Tracker.pickup_task(task_id, user) do
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
    task_id = String.to_integer(id)

    case Tracker.complete_task(task_id, user) do
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

  def delete(conn, _params, user) do
  end
end
