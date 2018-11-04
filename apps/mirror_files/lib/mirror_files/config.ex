defmodule Mirror.Files.Config do
  @spec aws_region() :: String.t
  def aws_region, do: config(:aws_region)

  @spec aws_bucket() :: String.t
  def aws_bucket, do: config(:aws_bucket)

  @spec aws_path() :: String.t
  def aws_path, do: config(:aws_path)

  @spec config(atom) :: any
  defp config(name), do: Application.get_env(:mirror_files, name)
end
