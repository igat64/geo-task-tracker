# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GeoTaskTracker.Repo.insert!(%GeoTaskTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Ecto.Changeset
alias GeoTaskTracker.Repo
alias GeoTaskTracker.Accounts.User

users = [
  %{
    id: 1,
    name: "Mike",
    role: "driver"
  },
  %{
    id: 2,
    name: "Dave",
    role: "manager"
  }
]

Enum.each(users, fn data ->
  %User{}
  |> Changeset.cast(data, [:id, :name, :role])
  |> Repo.insert()
end)
