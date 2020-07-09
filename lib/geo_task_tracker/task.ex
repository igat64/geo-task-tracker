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

  @required_fields ~w(title status pickup_point delivery_point)a
  @optional_fields ~w(assigned_user_id)a

  @doc false
  def changeset(%GeoTaskTracker.Task{} = task, attrs \\ %{}) do
    task
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:title, max: 256)
    |> validate_inclusion(:status, ["new", "assigned", "done"])
  end
end
