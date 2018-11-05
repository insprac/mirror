defmodule Mirror.Backup.Config do
  @spec timezone() :: Mirror.Backup.DateTime.timezone
  def timezone, do: config(:timezone, "Antarctica/Troll")

  @spec automatic_backups() :: list(Keyword.t)
  def automatic_backups, do: config(:automatic_backups, [])

  @spec config(atom, any) :: any
  def config(name, default \\ nil) do
    Application.get_env(:mirror_backup, name, default)
  end
end
