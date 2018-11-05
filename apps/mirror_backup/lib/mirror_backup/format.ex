defmodule Mirror.Backup.Format do
  alias Mirror.Backup
  alias Mirror.Database.Postgres.PSQL

  @spec s3_backup_path(PSQL.db_name, Backup.DateTime.t) :: Mirror.Files.path
  def s3_backup_path(db_name, datetime) do
    year = Timex.format!(datetime, "%y", :strftime)
    month = Timex.format!(datetime, "%m", :strftime)
    day = Timex.format!(datetime, "%d", :strftime)
    time = Timex.format!(datetime, "%H_%M_%S", :strftime)

    "/#{db_name}/#{year}/#{month}/#{day}/backup_#{time}.sql"
  end
end
