defmodule GeoTaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def up do
    create table(:tasks) do
      add :title, :string
      add :status, :string
      add :pickup_point, :geometry
      add :delivery_point, :geometry
      add :assigned_user_id, references(:users, on_delete: :restrict), null: true

      timestamps()
    end
  end

  def down do
    drop table(:tasks)
  end
end
