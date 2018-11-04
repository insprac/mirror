defmodule Mirror.Backup do
  alias Mirror.Files
  alias Mirror.Database.Postgres
  alias Mirror.Database.Postgres.PSQL

  @spec backup(PSQL.db_name, Files.path, PSQL.options) :: Files.S3.response
  def backup(db_name, s3_path, options \\ []) do
    case Postgres.dump_database(db_name, options) do
      {:ok, local_path} ->
        case File.read(local_path) do
          {:ok, content} ->
            case Files.S3.upload(s3_path, content) do
              {:ok, _} -> {:ok, db_name}
              {:error, _} -> {:error, :s3_upload_failed}
            end
          {:error, _} ->
            {:error, :read_dump_fail}
        end
      {:error, _} ->
        {:error, :dump_fail}
    end
  end
end
