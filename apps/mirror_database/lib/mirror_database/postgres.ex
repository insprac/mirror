defmodule Mirror.Database.Postgres do
  alias Mirror.Database.Postgres.{PSQL, PGDump}
  import PSQL, only: [psql: 1, psql: 2]
  import PGDump, only: [pg_dump: 1, pg_dump: 2]

  @type db_name :: String.t | atom

  @spec create_database(PSQL.db_name, PSQL.options) :: PSQL.result
  def create_database(db_name, options \\ []) do
    psql(options ++ [command: "CREATE DATABASE #{db_name};"])
  end

  @spec dump_database(PGDump.db_name, PGDump.options) :: PGDump.result
  def dump_database(db_name, options \\ []) do
    output_path = "#{System.tmp_dir()}/#{System.unique_integer([:positive])}"

    case pg_dump("#{db_name}", options ++ [file: output_path]) do
      {:ok, _output} -> {:ok, output_path}
      {:error, error} -> {:error, error}
    end
  end

  @spec execute_command(PSQL.db_name, PSQL.command, PSQL.options) :: PSQL.result
  def execute_command(db_name, command, options \\ []) do
    psql(options ++ [db_name: db_name, command: command])
  end

  @spec execute_script(PSQL.db_name, PSQL.path, PSQL.options) :: PSQL.result
  def execute_script(db_name, path, options \\ []) do
    psql(options ++ [file: path, db_name: db_name])
  end
end
