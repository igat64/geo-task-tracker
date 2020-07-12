defmodule GeoTaskTracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :role, :string

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :role])
    |> validate_required([:name, :role])
    |> validate_inclusion(:role, ["manager", "driver"])
  end
end
