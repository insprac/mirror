defmodule Mirror.BackupTest do
  use ExUnit.Case
  doctest Mirror.Backup

  test "greets the world" do
    assert Mirror.Backup.hello() == :world
  end
end
