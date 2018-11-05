defmodule Mirror.Backup.DateTime.Interval do
  import Mirror.Backup.DateTime
  alias Mirror.Backup

  @spec until(Backup.DateTime.period) :: Backup.DateTime.milliseconds
  def until(period), do: Timex.diff(now(), next(period), :milliseconds)

  @spec next(Backup.DateTime.period) :: DateTime.t
  def next(:month) do
    now() |> Timex.shift(months: 1) |> Timex.beginning_of_month()
  end
  def next(:week) do
    now() |> Timex.shift(weeks: 1) |> Timex.beginning_of_week()
  end
  def next(:day), do: %{next(:hour) | hour: 0}
  def next(:hour), do: %{next(:minute) | minute: 0}
  def next(:minute), do: %{now() | second: 0, microsecond: {0, 0}}
end
