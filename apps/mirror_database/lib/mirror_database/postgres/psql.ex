defmodule Mirror.Database.Postgres.PSQL do
  alias Mirror.Database.Config
  use Mirror.Database.Postgres.Command,
    name: :psql,
    executable: Config.get(:postgres_psql_path, optional: false)

  @type command :: String.t
end
