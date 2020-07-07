defmodule GeoTaskTrackerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use GeoTaskTrackerWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> put_view(GeoTaskTrackerWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(422)
    |> put_view(GeoTaskTrackerWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
end
