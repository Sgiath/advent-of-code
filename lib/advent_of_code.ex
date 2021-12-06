defmodule AdventOfCode do
  @moduledoc """
  Behaviour and helper functions for Advent of Code day solutions
  """

  defmacro __using__(opts) do
    year = Keyword.get(opts, :year)
    day = Keyword.get(opts, :day)
    path = "#{year}/day#{day |> Integer.to_string() |> String.pad_leading(2, "0")}.in"

    quote do
      @behaviour AdventOfCode

      @spec input_data() :: String.t()
      def input_data do
        [Application.app_dir(:advent_of_code, "priv"), unquote(path)]
        |> Path.join()
        |> File.read!()
      end

      @impl AdventOfCode
      def bench, do: %{part1: &part1/1, part2: &part2/1}
      defoverridable bench: 0
    end
  end

  @callback input :: input :: any()
  @callback part1(input :: any()) :: output :: any()
  @callback part2(input :: any()) :: output :: any()
  @callback bench :: configuration :: map() | [map()]
end
