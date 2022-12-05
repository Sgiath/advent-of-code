defmodule AdventOfCode do
  @moduledoc ~S"""
  Behaviour and helper functions for Advent of Code day solutions
  """

  defmacro __using__(_opts) do
    quote do
      @behaviour AdventOfCode

      @impl AdventOfCode
      def bench, do: %{part1: &part1/1, part2: &part2/1}
      defoverridable bench: 0
    end
  end

  @callback test_input :: String.t()
  @callback input :: String.t()
  @callback part1(input :: String.t()) :: output :: any()
  @callback part2(input :: String.t()) :: output :: any()
  @callback bench :: map() | [map()]
end
