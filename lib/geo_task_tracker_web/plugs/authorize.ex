defmodule GeoTaskTrackerWeb.AuthorizePlug do
  import Plug.Conn
  import Phoenix.Controller

  alias GeoTaskTrackerWeb.Authorization

  def init(opts), do: opts

  def call(conn, opts) do
    user = conn.assigns.user
    action = Keyword.get(opts, :action)
    resource = Keyword.get(opts, :resource)

    if Authorization.authorized?(user, action, resource) do
      conn
    else
      conn
      |> halt()
      |> put_status(403)
      |> put_view(GeoTaskTrackerWeb.ErrorView)
      |> render("403.json")
    end
  end
end
