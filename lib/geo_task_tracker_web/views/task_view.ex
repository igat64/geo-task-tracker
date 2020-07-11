defmodule GeoTaskTrackerWeb.TaskView do
  use GeoTaskTrackerWeb, :view

  def render("task.json", %{task: task}) do
    {dp_lat, dp_lon} = task.delivery_point.coordinates
    {pp_lat, pp_lon} = task.pickup_point.coordinates

    %{
      id: task.id,
      title: task.title,
      status: task.status,
      pickup_point: %{lat: pp_lat, lon: pp_lon},
      delivery_point: %{lat: dp_lat, lon: dp_lon},
      assigned_user_id: task.assigned_user_id
    }
  end

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, __MODULE__, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, __MODULE__, "task.json")}
  end
end
