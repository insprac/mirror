defmodule Mirror.Backup.AutomaticBackup do
  @moduledoc """
  # Example

      iex> {:ok, pid} = Mirror.Backup.AutomaticBackup.start_link([
        db_name: :some_database,
        backup_period: :day
      ])
      # {:ok, #PID<0.1.0>}

  """

  use GenServer
  alias Mirror.Backup
  alias Mirror.Database.Postgres.PSQL

  defmodule State do
    defstruct [
      db_name: nil,
      backup_period: :day,
      psql_options: [],
      path_formatter: nil
    ]

    @type t :: %__MODULE__{
      db_name: PSQL.db_name,
      backup_period: Backup.DateTime.period,
      psql_options: list(PSQL.option),
      path_formatter: function
    }

    @spec cast(Keyword.t) :: t
    def cast(options) do
      %__MODULE__{
        db_name: Keyword.get(options, :db_name),
        backup_period: Keyword.get(options, :backup_period, :day),
        psql_options: Keyword.get(options, :psql_options, []),
        path_formatter: Keyword.get(options, :path_formatter, fn state ->
          Backup.Format.s3_backup_path(state.db_name, Backup.DateTime.now())
        end)
      }
    end
  end

  @spec start_link(Keyword.t) :: {:ok, pid} | {:error, term}
  def start_link(options) do
    GenServer.start_link(__MODULE__, State.cast(options))
  end

  @spec init(State.t) :: {:ok, State.t}
  def init(state) do
    schedule_backup(self(), state)
    {:ok, state}
  end

  @spec handle_info(:backup, State.t) :: {:noreply, State.t}
  def handle_info(:backup, state) do
    path = state.path_formatter.(state)

    case Mirror.Backup.backup(state.db_name, path) do
      {:ok, _} ->
        IO.inspect({"Backed up", path})
      {:error, error} ->
        IO.inspect({"Failed to back up", error})
    end

    schedule_backup(self(), state)

    {:noreply, state}
  end

  @spec schedule_backup(pid, State.t) :: reference
  defp schedule_backup(pid, state) do
    interval = Backup.DateTime.Interval.until(state.backup_period)
    Process.send_after(pid, :backup, interval)
  end
end
