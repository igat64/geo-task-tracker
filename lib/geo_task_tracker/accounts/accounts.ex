defmodule GeoTaskTracker.Accounts do
  alias GeoTaskTracker.Accounts.User
  alias GeoTaskTracker.Repo

  def get_user(id) do
    Repo.get(User, id)
  end
end
