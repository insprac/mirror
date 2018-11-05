use Mix.Config

config :mirror_backup,
  timezone: "Pacific/Auckland",
  automatic_backups: [
    [
      db_name: :some_database,
      backup_period: :day,
      psql_options: [
        host: "https://some_host",
        username: "some_user",
        password: "password"
      ]
    ]
  ]
