defmodule Mirror.Backup.Application do
  use Application
  alias Mirror.Backup.Config

  def start(_type, _args) do
    # List all child processes to be supervised
    # children = [
      # Starts a worker by calling: Mirror.Backup.Worker.start_link(arg)
      # {Mirror.Backup.Worker, arg},
    # ]

    children = Enum.map(Config.automatic_backups(), fn options ->
      {Mirror.Backup.AutomaticBackup, options}
    end)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mirror.Backup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
