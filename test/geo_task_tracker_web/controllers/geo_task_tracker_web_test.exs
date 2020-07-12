defmodule GeoTaskTrackerWeb.PageControllerTest do
  use GeoTaskTrackerWeb.ConnCase
  import GeoTaskTracker.Factories

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "POST /tasks" do
    @valid_task_attrs %{
      title: "Haul the cargo",
      pickup_point: %{lat: 90, lon: 0},
      delivery_point: %{lat: -90, lon: 0}
    }

    @invalid_task_attrs %{
      title: "",
      pickup_point: %{},
      delivery_point: %{lat: -90}
    }

    test "renders 401 when not authenticated", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create, @valid_task_attrs))
      assert json_response(conn, 401)
    end

    test "renders 403 when not authorized", %{conn: conn} do
      {conn, _user} = authenticate(conn, "driver")

      conn = post(conn, Routes.task_path(conn, :create, @valid_task_attrs))
      assert json_response(conn, 403)
    end

    test "renders 422 when data is invalid", %{conn: conn} do
      {conn, _user} = authenticate(conn, "manager")

      conn = post(conn, Routes.task_path(conn, :create), @invalid_task_attrs)
      assert json_response(conn, 422)
    end

    test "renders 201 and create a task when data is valid and user is manager", %{conn: conn} do
      {conn, _user} = authenticate(conn, "manager")

      conn = post(conn, Routes.task_path(conn, :create), @valid_task_attrs)
      assert json_response(conn, 201)
    end
  end

  describe "POST /tasks/:id/pickup" do
    test "renders 200 when task exists and user is driver", %{conn: conn} do
      {conn, user} = authenticate(conn, "driver")
      task = insert(:task, status: "new")

      conn = post(conn, Routes.task_path(conn, :pickup, task))

      assert %{
               "id" => task.id,
               "title" => task.title,
               "status" => "assigned",
               "assigned_user_id" => user.id,
               "delivery_point" => %{
                 "lat" => elem(task.delivery_point.coordinates, 0),
                 "lon" => elem(task.delivery_point.coordinates, 1)
               },
               "pickup_point" => %{
                 "lat" => elem(task.pickup_point.coordinates, 0),
                 "lon" => elem(task.pickup_point.coordinates, 1)
               }
             } == json_response(conn, 200)["data"]
    end
  end

  defp authenticate(conn, role) do
    user = insert(:user, role: role)
    token = Phoenix.Token.sign(GeoTaskTrackerWeb.Endpoint, "user", user.id)
    conn = put_req_header(conn, "authorization", token)
    {conn, user}
  end
end
