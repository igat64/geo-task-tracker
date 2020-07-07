defmodule GeoTaskTrackerWeb.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller

  alias GeoTaskTrackerWeb.{Authentication}

  def init(opts), do: opts

  def call(conn, _opts) do
    case Authentication.authenticate(conn) do
      {:ok, user} ->
        assign(conn, :user, user)

      {:error, reason} ->
        conn
        |> put_status(401)
        |> put_view(GeoTaskTrackerWeb.ErrorView)
        |> render("401.json", message: reason)
    end
  end
end
