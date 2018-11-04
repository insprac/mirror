defmodule Mirror.Database.Config do
  @type get_option :: {:optional, boolean}

  @spec get(atom, list(get_option)) :: any
  def get(name, opts \\ []) do
    case Application.get_env(:mirror_database, name) do
      nil ->
        case Keyword.get(opts, :optional, true) do
          true -> nil
          _ -> raise "#{name} must be configured"
        end
      value ->
        value
    end
  end
end
