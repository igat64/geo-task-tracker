Postgrex.Types.define(
  GeoTaskTracker.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions()
)
