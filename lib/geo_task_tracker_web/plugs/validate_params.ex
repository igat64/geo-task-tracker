defmodule GeoTaskTrackerWeb.ValidateParamsPlug do
  import Plug.Conn
  import Phoenix.Controller

  alias ExJsonSchema.Validator

  def init(opts), do: opts

  def call(conn, schema: schema, error_status: status) do
    case Validator.validate(schema, conn.params) do
      :ok ->
        conn

      {:error, _errors} ->
        conn
        |> halt()
        |> put_status(status)
        |> put_view(GeoTaskTrackerWeb.ErrorView)
        # TODO: propagate and render errors
        |> render("#{status}.json")
    end
  end
end
