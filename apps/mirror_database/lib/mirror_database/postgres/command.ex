defmodule Mirror.Database.Postgres.Command do
  defmacro __using__(opts) do
    quote do
      @type executable_path :: String.t
      @type option :: {atom, any}
      @type parsed_options :: {list(argument), list(env_value)}
      @type argument :: any
      @type env_value :: {String.t, String.t}
      @type db_name :: String.t | atom
      @type path :: String.t
      @type output :: String.t
      @type error :: %{output: output, error_code: integer}
      @type result :: {:ok, output} | {:error, error}

      @spec executable() :: executable_path
      def executable, do: Keyword.get(unquote(opts), :executable)

      @spec unquote(Keyword.get(opts, :name))(list(option)) :: result
      def unquote(Keyword.get(opts, :name))(options) do
        {arguments, env_values} = parse_options(options)
        cmd(executable(), arguments, env: env_values)
      end

      @spec unquote(Keyword.get(opts, :name))(argument, list(option)) :: result
      def unquote(Keyword.get(opts, :name))(arg, options) do
        {arguments, env_values} = parse_options(options)
        cmd(executable(), arguments ++ [arg], env: env_values)
      end

      @spec cmd(executable_path, list(argument), Keyword.t) :: result
      def cmd(executable, arguments, options \\ []) do
        case System.cmd(executable, arguments, options) do
          {output, 0} -> {:ok, output}
          {output, code} -> {:error, %{output: output, error_code: code}}
        end
      end

      @spec parse_options(list(option)) :: parsed_options
      def parse_options(options), do: parse_options(options, {[], []})

      @spec parse_options(list(option), parsed_options) :: parsed_options
      def parse_options([], parsed_options), do: parsed_options
      def parse_options([option | options], {arguments, env_values}) do
        parsed_options = 
          try do
            {arg(option) ++ arguments, env_values}
          rescue
            _ ->
              try do
                {arguments, env(option) ++ env_values}
              rescue
                e ->
                  IO.inspect({:unknown_option, option})
                  {arguments, env_values}
              end
          end

        parse_options(options, parsed_options)
      end

      @spec arg(option) :: list(argument)
      def arg({:file, path}), do: ["--file=#{path}"]
      def arg({:db_name, db_name}), do: ["--dbname=#{db_name}"]
      def arg({:username, username}), do: ["--username=#{username}"]
      def arg({:host, host}), do: ["--host=#{host}"]
      def arg({:port, port}), do: ["--port=#{port}"]
      def arg({:command, command}), do: ["--command=#{command}"]

      @spec env(option) :: list(env_value)
      def env({:password, password}), do: [{"PGPASSWORD", password}]
    end
  end
end
