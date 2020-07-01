defmodule GeoTaskTracker.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :status, :string
    field :pickup_point, Geo.PostGIS.Geometry
    field :delivery_point, Geo.PostGIS.Geometry
    belongs_to :assigned_user, GeoTaskTracker.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
