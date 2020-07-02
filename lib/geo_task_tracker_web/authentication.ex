defmodule GeoTaskTrackerWeb.Authentication do
  import Plug.Conn

  alias GeoTaskTracker.{Account, User}

  @doc """
  {:ok, user}               - user associated with token
  {:error, :auth_missed}    - "authorization" header is missed
  {:error, :user_not_exist} - user id stored in auth token is no longer exists
  {:error, :invalid}        - token is invalid
  {:error, :expired}        - token has expired
  """
  def authenticate(conn) do
    with {:ok, token} <- extract_token(conn),
         {:ok, user_id} <- verify_token(conn, token),
         {:ok, user} <- find_user(user_id),
         do: {:ok, user}
  end

  defp extract_token(conn) do
    case get_req_header(conn, "authorization") do
      [token] -> {:ok, token}
      _ -> {:error, :auth_missed}
    end
  end

  defp verify_token(conn, token) do
    Phoenix.Token.verify(conn, "user auth", token)
  end

  defp find_user(user_id) do
    case Account.get_user(user_id) do
      %User{} = user -> {:ok, user}
      _ -> {:error, :user_not_exist}
    end
  end
end
