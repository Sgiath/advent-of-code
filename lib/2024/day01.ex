defmodule AdventOfCode.Year2024.Day01 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/1
  """
  use AdventOfCode, year: 2024, day: 01

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """
  end

  def parse(input) do
    [_first | data2] = data1 = input
    |> String.split(["\n", "   "], trim: true)
    |> Enum.map(&String.to_integer/1)

    list1 = Enum.take_every(data1, 2)
    list2 = Enum.take_every(data2, 2)

    {list1, list2}
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    {list1, list2} = parse(input)

    list1
    |> Enum.sort()
    |> Enum.zip(Enum.sort(list2))
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    {list1, list2} = parse(input)

    freq = Enum.frequencies(list2)

    list1
    |> Enum.map(fn a -> a * Map.get(freq, a, 0) end)
    |> Enum.sum()
  end
end
