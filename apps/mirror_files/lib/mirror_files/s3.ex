defmodule Mirror.Files.S3 do
  alias Mirror.Files
  alias Mirror.Files.Config

  @type response :: {:ok, term} | {:error, term}

  @spec upload(Files.path, Files.file_content) :: response
  def upload(path, content) do
    ExAws.S3.put_object(Config.aws_bucket(), path(path), content)
    |> request()
  end

  @spec download(Files.path, Files.path) :: response
  def download(s3_path, local_path) do
    ExAws.S3.download_file(Config.aws_bucket(), path(s3_path), local_path)
    |> request()
  end

  @spec request(ExAws.Operation.S3.t()) :: response
  defp request(request) do
    ExAws.request(request, region: Config.aws_region())
  end

  @spec link(Files.path) :: String.t
  defp link(path), do: "https://#{domain()}/#{Config.aws_bucket()}#{path(path)}"

  @spec domain() :: String.t
  defp domain, do: "s3-#{Config.aws_region()}.amazonaws.com"

  @spec path(Files.path) :: Files.path
  def path(path), do: "#{Config.aws_path()}#{path}"
end
