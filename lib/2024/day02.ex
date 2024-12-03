defmodule AdventOfCode.Year2024.Day02 do
  @moduledoc ~S"""
  https://adventofcode.com/2024/day/2
  """
  use AdventOfCode, year: 2024, day: 02

  # =============================================================================================
  # Input
  # =============================================================================================

  @impl AdventOfCode
  def test_input do
    """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """
  end

  def parse(input) do
    input
    |> String.split(["\n"], trim: true)
    |> Enum.map(&String.split(&1, [" "], trim: true))
    |> Enum.map(fn r ->
      Enum.map(r, &String.to_integer/1)
    end)
  end

  # =============================================================================================
  # Part 1
  # =============================================================================================

  @impl AdventOfCode
  def part1(input) do
    input
    |> parse()
    |> Enum.count(&safe?/1)
  end

  # =============================================================================================
  # Part 2
  # =============================================================================================

  @impl AdventOfCode
  def part2(input) do
    input
    |> parse()
    |> Enum.count(fn report ->
      Enum.any?(0..(length(report) - 1), fn i ->
        report
        |> List.delete_at(i)
        |> safe?()
      end)
    end)
  end

  # =============================================================================================
  # Utils
  # =============================================================================================

  def safe?(report) do
    {diff, _a} =
      Enum.reduce(report, {[], nil}, fn
        a, {[], nil} -> {[], a}
        a, {r, b} -> {[a - b | r], a}
      end)

    (Enum.all?(diff, &(&1 > 0)) or
       Enum.all?(diff, &(&1 < 0))) and
      Enum.all?(diff, &(abs(&1) <= 3))
  end
end
