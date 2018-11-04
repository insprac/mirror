defmodule Mirror.DatabaseTest do
  use ExUnit.Case
  doctest Mirror.Database

  test "greets the world" do
    assert Mirror.Database.hello() == :world
  end
end
