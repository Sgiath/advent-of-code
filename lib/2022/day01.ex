defmodule AdventOfCode.Year2022.Day01 do
  @moduledoc ~S"""
  https://adventofcode.com/2022/day/1
  """
  use AdventOfCode, year: 2022, day: 1

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    """
  end

  def parse(input) do
    input
    |> String.split(["\n\n"], trim: true)
    |> Enum.map(fn calories ->
      calories
      |> AdventOfCode.Parser.lines()
      |> Enum.sum()
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.max()
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
