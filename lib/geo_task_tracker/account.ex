defmodule GeoTaskTracker.Account do
  alias GeoTaskTracker.{User, Repo}

  def get_user(id) do
    Repo.get(User, id)
  end
end
