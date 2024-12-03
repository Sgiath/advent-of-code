defmodule AdventOfCode do
  @moduledoc ~S"""
  Behaviour and helper functions for Advent of Code day solutions
  """

  defmacro __using__(opts) do
    year = Keyword.fetch!(opts, :year) |> Integer.to_string()
    day = Keyword.fetch!(opts, :day) |> Integer.to_string() |> String.pad_leading(2, "0")
    path = Application.app_dir(:advent_of_code, ["priv", year, "day#{day}.in"])

    quote do
      @behaviour AdventOfCode

      import NimbleParsec

      @impl AdventOfCode
      def input do
        File.read!(unquote(path))
      end

      @impl AdventOfCode
      def bench, do: %{part1: &part1/1, part2: &part2/1}
      defoverridable bench: 0
    end
  end

  @callback test_input :: String.t() | [String.t()]
  @callback input :: String.t()
  @callback part1(input :: String.t()) :: output :: any()
  @callback part2(input :: String.t()) :: output :: any()
  @callback bench :: map() | [map()]
end
