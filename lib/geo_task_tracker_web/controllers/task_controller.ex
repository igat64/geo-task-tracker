defmodule GeoTaskTrackerWeb.TaskController do
  use GeoTaskTrackerWeb, :controller

  alias GeoTaskTrackerWeb.{AuthorizePlug, ValidateParamsPlug}
  alias GeoTaskTracker.Tracker
  alias ExJsonSchema.Schema

  @task_params_schema %{
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
                      }
                      |> Schema.resolve()

  @task_nearby_params_schema %{
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
                             }
                             |> Schema.resolve()

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

  def create(conn, params) do
    with {:ok, task} <- Tracker.create_task(params) do
      conn
      |> put_status(201)
      |> render("show.json", task: task)
    end
  end

  def find_nearby(conn, %{"lat" => lat, "lon" => lon}) do
    with {:ok, lat} <- parse_nearby_param(lat),
         {:ok, lon} <- parse_nearby_param(lon),
         {:ok, tasks} <- Tracker.find_tasks_nearby({lat, lon}) do
      conn
      |> put_status(200)
      |> render("index.json", tasks: tasks)
    else
      _ ->
        {:error, :bad_request}
    end
  end

  def pickup(conn, %{"id" => id}) do
    user = conn.assigns.user

    with {:ok, task} <- Tracker.get_task!(id) |> Tracker.pickup_task(user) do
      conn
      |> put_status(200)
      |> render("show.json", task: task)
    end
  end

  def complete(conn, %{"id" => id}) do
    with {:ok, task} <- Tracker.get_task!(id) |> Tracker.complete_task() do
      conn
      |> put_status(200)
      |> render("show.json", task: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _task} <- Tracker.get_task!(id) |> Tracker.delete_task() do
      resp(conn, 204, "")
    end
  end

  defp parse_nearby_param(param) do
    case Regex.run(~r{^[+-]?\d+(\.\d+)?$}, param) do
      [match | _] ->
        {:ok, match |> Float.parse() |> elem(0)}

      nil ->
        {:error, :malformed}
    end
  end
end
