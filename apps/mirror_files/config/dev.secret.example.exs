# Rename to dev.secret.exs

use Mix.Config
  
config :ex_aws,
  access_key_id: "access_key",
  secret_access_key: "secret_access_key"

config :mirror_files,
  aws_region: "ap-southeast-2",
  aws_bucket: "bucket_name",
  aws_path: "/database/backups"
