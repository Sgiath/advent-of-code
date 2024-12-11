defmodule AdventOfCode.Year2024.Day11 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/11

  The stones are independent so we can expand each of them separately. I tested it also
  asynchronously but with `Memoize` it was actually slower.
  """
  use AdventOfCode, year: 2024, day: 11
  use Memoize

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    125 17
    """
  end

  def parse(input) do
    input
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&expand(&1, 25))
    |> Enum.sum()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.map(&expand(&1, 75))
    |> Enum.sum()
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  defmemo transform(0) do
    [1]
  end

  defmemo transform(num) do
    d = Integer.digits(num)
    l = length(d)

    if rem(l, 2) == 0 do
      {first, second} = Enum.split(d, div(l, 2))
      [Integer.undigits(first), Integer.undigits(second)]
    else
      [num * 2024]
    end
  end

  defmemo expand(_num, 0) do
    1
  end

  defmemo expand(num, blinks) do
    num
    |> transform()
    |> Enum.map(&expand(&1, blinks - 1))
    |> Enum.sum()
  end
end
