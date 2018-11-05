defmodule Mirror.Backup.MixProject do
  use Mix.Project

  def project do
    [
      app: :mirror_backup,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mirror.Backup.Application, []}
    ]
  end

  defp deps do
    [
      {:timex, "~> 3.4"},
      {:mirror_database, in_umbrella: true},
      {:mirror_files, in_umbrella: true}
    ]
  end
end
