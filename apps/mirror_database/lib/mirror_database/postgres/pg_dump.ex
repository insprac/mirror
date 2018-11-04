defmodule Mirror.Database.Postgres.PGDump do
  alias Mirror.Database.Config
  use Mirror.Database.Postgres.Command,
    name: :pg_dump,
    executable: Config.get(:postgres_pg_dump_path, optional: false)
end
