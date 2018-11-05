defmodule Mirror.Backup.DateTime do
  @type timezone :: String.t
  @type milliseconds :: integer
  @type period :: :milliseconds | :second | :minute | :hour | :day | :week |
    :month | :year

  @spec now() :: DateTime.t
  def now, do: Timex.now(Mirror.Backup.Config.timezone())
end
