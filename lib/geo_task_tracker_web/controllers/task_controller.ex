defmodule GeoTaskTrackerWeb.TaskController do
  use GeoTaskTrackerWeb, :controller

  alias GeoTaskTrackerWeb.{AuthorizePlug, ValidateParamsPlug}
  alias GeoTaskTracker.Tracker
  alias ExJsonSchema.Schema

  @task_params_schema Schema.resolve(%{
                        "type" => "object",
                        "required" => ["title", "pickup_point", "delivery_point"],
                        "properties" => %{
                          "title" => %{"type" => "string", "minLength" => 1, "maxLength" => 256},
                          "pickup_point" => %{"$ref" => "#/definitions/point"},
                          "delivery_point" => %{"$ref" => "#/definitions/point"}
                        },
                        "definitions" => %{
                          "point" => %{
                            "type" => "object",
                            "required" => ["lat", "lon"],
                            "properties" => %{
                              "lat" => %{"type" => "number", "minimum" => -90, "maximum" => 90},
                              "lon" => %{"type" => "number", "minimum" => -90, "maximum" => 90}
                            }
                          }
                        }
                      })

  @task_nearby_params_schema Schema.resolve(%{
                               "type" => "object",
                               "required" => ["lat", "lon"],
                               "properties" => %{
                                 "lat" => %{"$ref" => "#/definitions/lat_lon"},
                                 "lon" => %{"$ref" => "#/definitions/lat_lon"}
                               },
                               "definitions" => %{
                                 "lat_lon" => %{
                                   "type" => "string",
                                   "minLength" => 1,
                                   "maxLength" => 16
                                 }
                               }
                             })

  plug AuthorizePlug,
       [action: "create", resource: "task"]
       when action in [:create]

  plug AuthorizePlug,
       [action: "find_nearby", resource: "task"]
       when action in [:find_nearby]

  plug AuthorizePlug,
       [action: "pickup", resource: "task"]
       when action in [:pickup]

  plug AuthorizePlug,
       [action: "complete", resource: "task"]
       when action in [:complete]

  plug AuthorizePlug,
       [action: "delete", resource: "task"]
       when action in [:delete]

  plug ValidateParamsPlug,
       [schema: @task_params_schema, error_status: 422]
       when action in [:create]

  plug ValidateParamsPlug,
       [schema: @task_nearby_params_schema, error_status: 400]
       when action in [:find_nearby]

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
    with {:ok, lat} <- parse_nearby_param(lat),
         {:ok, lon} <- parse_nearby_param(lon),
         {:ok, tasks} <- Tracker.find_tasks_nearby({lat, lon}, user) do
      conn
      |> put_status(200)
      |> render("index.json", tasks: tasks)
    else
      _ ->
        {:error, :bad_request}
    end
  end

  def pickup(conn, %{"id" => id}, user) do
    with {:ok, task} <- Tracker.pickup_task(id, user) do
      conn
      |> put_status(200)
      |> render("show.json", task: task)
    end
  end

  def complete(conn, %{"id" => id}, user) do
    with {:ok, task} <- Tracker.complete_task(id, user) do
      conn
      |> put_status(200)
      |> render("show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    with {:ok, _} <- Tracker.delete_task(id, user) do
      resp(conn, 204, "")
    end
  end

  defp parse_nearby_param(param) do
    case Regex.run(~r{^[+-]?\d+(\.\d+)?$}, param) do
      [match | _] ->
        {:ok, match |> Float.parse() |> elem(0)}

      nil ->
        {:error, :bad_input}
    end
  end
end
