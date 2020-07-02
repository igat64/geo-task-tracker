defmodule GeoTaskTrackerWeb.AuthPlug do
  import Plug.Conn

  alias GeoTaskTrackerWeb.{Authentication}

  def init(opts), do: opts

  def call(conn, _opts) do
    case Authentication.authenticate(conn) do
      {:ok, user} ->
        assign(conn, :user, user)

      {:error, _reason} ->
        conn |> halt() |> resp(401, "")
    end
  end
end
