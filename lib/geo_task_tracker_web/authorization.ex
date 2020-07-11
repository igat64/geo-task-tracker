defmodule GeoTaskTrackerWeb.Authorization do
  alias GeoTaskTracker.Accounts.User

  @policies %{
    "manager" => %{
      "task" => ["create", "delete"]
    },
    "driver" => %{
      "task" => ["find_nearby", "pickup", "complete"]
    }
  }

  def authorized?(%User{} = user, action, resource) do
    permitted_actions = get_in(@policies, [user.role, resource]) || []
    action in permitted_actions
  end
end
