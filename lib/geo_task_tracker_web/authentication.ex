defmodule GeoTaskTrackerWeb.Authentication do
  import Plug.Conn

  alias GeoTaskTracker.Accounts
  alias GeoTaskTracker.Accounts.User

  def authenticate(conn) do
    with {:ok, token} <- extract_token(conn),
         {:ok, user_id} <- verify_token(conn, token),
         {:ok, user} <- find_user(user_id),
         do: {:ok, user}
  end

  defp extract_token(conn) do
    case get_req_header(conn, "authorization") do
      [token] -> {:ok, token}
      _ -> {:error, "The Authorization header is missed"}
    end
  end

  defp verify_token(conn, token) do
    case Phoenix.Token.verify(conn, "user auth", token) do
      {:error, :invalid} -> {:error, "The token is invalid"}
      {:error, :expired} -> {:error, "The token has expired"}
      result -> result
    end
  end

  defp find_user(user_id) do
    case Accounts.get_user(user_id) do
      %User{} = user -> {:ok, user}
      _ -> {:error, "The user is no longer exists"}
    end
  end
end
