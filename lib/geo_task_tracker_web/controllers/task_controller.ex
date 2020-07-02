defmodule GeoTaskTrackerWeb.TaskController do
  use GeoTaskTrackerWeb, :controller

  alias GeoTaskTracker.Tracker

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.user]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, params, _user) do
    case Tracker.create_task(params) do
      {:ok, task} ->
        conn
        |> put_status(201)
        |> render("task.json", task: task)

      {:error, _} ->
        put_status(conn, 500)
    end
  end
end
